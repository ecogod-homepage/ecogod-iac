variable "aws_profile" {
  type    = string
  default = "capstone"
}

variable "aws_region" {
  type    = string
  default = "ap-northeast-2"
}

variable "project" {
  type    = string
  default = "ecogod"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "root_domain" {
  type = string
}

variable "frontend_subdomain" {
  type    = string
  default = "www"
}

variable "api_subdomain" {
  type    = string
  default = "api"
}

variable "asset_subdomain" {
  type    = string
  default = "assets"
}

variable "db_name" {
  type    = string
  default = "ecogod"
}

variable "db_username" {
  type    = string
  default = "ecogod"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_pair_name" {
  type    = string
  default = "ecogod-dev"
}

variable "ssh_allowed_cidr" {
  type = string
}

variable "frontend_bucket_name" {
  type = string
}

variable "asset_bucket_name" {
  type = string
}

variable "ssm_parameter_prefix" {
  type    = string
  default = "/ecogod"
}

variable "tags" {
  type    = map(string)
  default = {}
}
