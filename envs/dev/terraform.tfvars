aws_profile          = "capstone"
aws_region           = "ap-northeast-2"
root_domain          = "ecogod.kr"
frontend_bucket_name = "ecogod-frontend-site"
asset_bucket_name    = "ecogod-asset-site"
db_name              = "ecogod"
db_username          = "ecogod"
key_pair_name        = "ecogod-dev"
ssh_allowed_cidr     = "118.221.254.20/32"

# Set at apply time instead of committing a value.
# Example:
# TF_VAR_db_password='change-me' terraform apply

tags = {
  Project     = "ecogod"
  Environment = "dev"
  ManagedBy   = "terraform"
}
