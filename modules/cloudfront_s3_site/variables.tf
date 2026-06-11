variable "aliases" {
  type = list(string)
}

variable "bucket_name" {
  type = string
}

variable "bucket_arn" {
  type = string
}

variable "bucket_domain_name" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "comment" {
  type    = string
  default = null
}

variable "spa_fallback" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
