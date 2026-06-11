variable "zone_id" {
  type = string
}

variable "domain_names" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
