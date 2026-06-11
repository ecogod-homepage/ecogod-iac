variable "instance_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "instance_profile_name" {
  type = string
}

variable "key_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
