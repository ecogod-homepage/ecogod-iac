output "frontend_url" {
  value = "https://${var.frontend_subdomain}.${var.root_domain}"
}

output "asset_url" {
  value = "https://${var.asset_subdomain}.${var.root_domain}"
}

output "api_url" {
  value = "https://${var.api_subdomain}.${var.root_domain}"
}

output "route53_name_servers" {
  value = module.route53_zone.name_servers
}

output "rds_endpoint" {
  value = module.rds_mysql_minimal.endpoint
}

output "ec2_public_ip" {
  value = module.ec2_caddy.public_ip
}
