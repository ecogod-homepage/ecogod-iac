locals {
  frontend_domain = "${var.frontend_subdomain}.${var.root_domain}"
  api_domain      = "${var.api_subdomain}.${var.root_domain}"
  asset_domain    = "${var.asset_subdomain}.${var.root_domain}"
  common_tags = merge(
    {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.tags
  )
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_vpc" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "route53_zone" {
  source = "../../modules/route53_zone"

  root_domain = var.root_domain
  tags        = local.common_tags
}

module "acm_certificate" {
  source = "../../modules/acm_certificate"

  providers = {
    aws = aws.us_east_1
  }

  zone_id      = module.route53_zone.zone_id
  domain_names = [local.frontend_domain, local.asset_domain]
  tags         = local.common_tags
}

module "frontend_bucket" {
  source = "../../modules/s3_bucket_private"

  bucket_name = var.frontend_bucket_name
  tags        = local.common_tags
}

module "asset_bucket" {
  source = "../../modules/s3_bucket_private"

  bucket_name = var.asset_bucket_name
  tags        = local.common_tags
}

module "frontend_distribution" {
  source = "../../modules/cloudfront_s3_site"

  aliases             = [local.frontend_domain]
  bucket_name         = module.frontend_bucket.bucket_name
  bucket_arn          = module.frontend_bucket.bucket_arn
  bucket_domain_name  = module.frontend_bucket.bucket_regional_domain_name
  acm_certificate_arn = module.acm_certificate.certificate_arn
  comment             = "ecogod frontend"
  spa_fallback        = true
  tags                = local.common_tags
}

module "asset_distribution" {
  source = "../../modules/cloudfront_s3_site"

  aliases             = [local.asset_domain]
  bucket_name         = module.asset_bucket.bucket_name
  bucket_arn          = module.asset_bucket.bucket_arn
  bucket_domain_name  = module.asset_bucket.bucket_regional_domain_name
  acm_certificate_arn = module.acm_certificate.certificate_arn
  comment             = "ecogod assets"
  spa_fallback        = false
  tags                = local.common_tags
}

module "web_security_group" {
  source = "../../modules/security_group"

  name        = "${var.project}-web"
  description = "Web ingress for ecogod API server"
  vpc_id      = data.aws_vpc.default.id
  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.ssh_allowed_cidr]
      description = "SSH"
    }
  ]
  tags = local.common_tags
}

module "db_security_group" {
  source = "../../modules/security_group"

  name        = "${var.project}-db"
  description = "MySQL access for ecogod RDS"
  vpc_id      = data.aws_vpc.default.id
  ingress_sg_rules = [
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      source_security_group_id = module.web_security_group.security_group_id
      description              = "MySQL from EC2"
    }
  ]
  tags = local.common_tags
}

module "iam_ec2_ssm" {
  source = "../../modules/iam_ec2_ssm"

  role_name             = "${var.project}-ec2-role"
  instance_profile_name = "${var.project}-ec2-profile"
  ssm_parameter_prefix  = var.ssm_parameter_prefix
  asset_bucket_arn      = module.asset_bucket.bucket_arn
  tags                  = local.common_tags
}

module "rds_mysql_minimal" {
  source = "../../modules/rds_mysql_minimal"

  identifier             = "${var.project}-mysql"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  allocated_storage      = var.db_allocated_storage
  subnet_ids             = data.aws_subnets.default_vpc.ids
  vpc_security_group_ids = [module.db_security_group.security_group_id]
  tags                   = local.common_tags
}

module "ec2_caddy" {
  source = "../../modules/ec2_caddy"

  instance_name          = "${var.project}-api"
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default_vpc.ids[0]
  vpc_security_group_ids = [module.web_security_group.security_group_id]
  instance_profile_name  = module.iam_ec2_ssm.instance_profile_name
  key_name               = var.key_pair_name
  domain_name            = local.api_domain
  tags                   = local.common_tags
}

module "ssm_namespace" {
  source = "../../modules/ssm_namespace"

  parameter_names = [
    "${var.ssm_parameter_prefix}/server/db/host",
    "${var.ssm_parameter_prefix}/server/db/name",
    "${var.ssm_parameter_prefix}/server/db/username",
    "${var.ssm_parameter_prefix}/server/db/password",
    "${var.ssm_parameter_prefix}/server/jwt/secret",
    "${var.ssm_parameter_prefix}/server/mail/username",
    "${var.ssm_parameter_prefix}/server/mail/password",
    "${var.ssm_parameter_prefix}/server/storage/s3/bucket",
    "${var.ssm_parameter_prefix}/server/storage/s3/public-base-url",
    "${var.ssm_parameter_prefix}/client/api/base-url"
  ]
  tags = local.common_tags
}

resource "aws_route53_record" "frontend_alias" {
  zone_id = module.route53_zone.zone_id
  name    = local.frontend_domain
  type    = "A"

  alias {
    name                   = module.frontend_distribution.domain_name
    zone_id                = module.frontend_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "asset_alias" {
  zone_id = module.route53_zone.zone_id
  name    = local.asset_domain
  type    = "A"

  alias {
    name                   = module.asset_distribution.domain_name
    zone_id                = module.asset_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "api_a" {
  zone_id = module.route53_zone.zone_id
  name    = local.api_domain
  type    = "A"
  ttl     = 300
  records = [module.ec2_caddy.public_ip]
}
