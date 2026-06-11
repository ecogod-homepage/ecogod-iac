terraform {
  backend "s3" {
    bucket       = "ecogod-tfstate"
    key          = "dev/terraform.tfstate"
    region       = "ap-northeast-2"
    use_lockfile = true
    profile      = "capstone"
  }
}
