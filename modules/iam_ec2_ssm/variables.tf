variable "role_name" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "ssm_parameter_prefix" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
