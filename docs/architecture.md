# Architecture

- `www.<root_domain>` -> CloudFront -> private S3 frontend bucket
- `assets.<root_domain>` -> CloudFront -> private S3 asset bucket
- `api.<root_domain>` -> Route53 A record -> EC2 Elastic IP -> Caddy -> app on `localhost:8080`
- EC2 and RDS run in the default VPC
- RDS is not publicly accessible and only allows traffic from the EC2 security group
- EC2 reads runtime secrets from SSM Parameter Store
