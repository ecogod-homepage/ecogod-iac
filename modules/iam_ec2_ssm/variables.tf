variable "role_name" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "ssm_parameter_prefix" {
  type = string
}

variable "asset_bucket_arn" {
  type = string
}

variable "asset_object_prefix" {
  type    = string
  default = "products/"
}

variable "tags" {
  type    = map(string)
  default = {}
}
