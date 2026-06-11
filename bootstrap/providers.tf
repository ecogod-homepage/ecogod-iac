variable "aws_profile" {
  type    = string
  default = "capstone"
}

variable "aws_region" {
  type    = string
  default = "ap-northeast-2"
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}
