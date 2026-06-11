resource "aws_db_subnet_group" "this" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

resource "aws_db_instance" "this" {
  identifier                   = var.identifier
  engine                       = "mysql"
  engine_version               = "8.0"
  instance_class               = "db.t3.micro"
  allocated_storage            = var.allocated_storage
  storage_type                 = "gp3"
  db_name                      = var.db_name
  username                     = var.username
  password                     = var.password
  db_subnet_group_name         = aws_db_subnet_group.this.name
  vpc_security_group_ids       = var.vpc_security_group_ids
  publicly_accessible          = false
  backup_retention_period      = 0
  skip_final_snapshot          = true
  delete_automated_backups     = true
  deletion_protection          = false
  auto_minor_version_upgrade   = false
  multi_az                     = false
  storage_encrypted            = true
  performance_insights_enabled = false
  monitoring_interval          = 0
  apply_immediately            = true

  tags = var.tags
}
