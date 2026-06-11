# ecogod-iac

Terraform infrastructure for ecogod.

## Scope
- Route53 public hosted zone
- S3 buckets for frontend and assets
- CloudFront for `www.<root_domain>` and `assets.<root_domain>`
- EC2 `t3.micro` with Caddy for `api.<root_domain>`
- RDS MySQL minimal-cost configuration
- SSM parameter namespace and EC2 IAM access

## Layout
- `bootstrap/`: remote state bucket bootstrap
- `envs/dev/`: single active environment
- `modules/`: reusable infrastructure modules

## AWS profile
Local CLI examples assume `--profile capstone`.
Terraform itself reads the profile from `envs/dev/terraform.tfvars`.

## Bootstrap
```bash
cd bootstrap
terraform init
terraform apply -var='aws_profile=capstone'
```

## Dev
1. Update `envs/dev/terraform.tfvars`
2. Seed runtime secrets outside Terraform
3. Apply:
```bash
cd envs/dev
terraform init
terraform plan
terraform apply
```

## Secret policy
Secret values are not stored in Terraform code by default. Seed values separately into SSM where possible.
The only unavoidable exception is the initial RDS master password input if you keep RDS creation inside Terraform.
