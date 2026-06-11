# Required AWS permissions for Terraform apply

## Already available in `capstone`
- `route53:*` at least hosted zone and record management subset
- `s3:*` at least bucket create and policy management subset
- `ec2:*` at least VPC describe, security group create, EIP allocate, instance run subset
- `rds:*` at least DB subnet group and DB instance create subset
- `iam:*` at least role create and pass role subset

## Missing in `capstone` from policy simulation
- `acm:ListCertificates`
- `acm:RequestCertificate`
- `acm:DescribeCertificate`
- `cloudfront:ListDistributions`
- `cloudfront:CreateDistribution`
- `cloudfront:GetDistributionConfig`
- `ssm:DescribeParameters`
- `ssm:GetParameter`
- `ssm:PutParameter`

## Practical minimum to add
- `acm:RequestCertificate`
- `acm:DescribeCertificate`
- `acm:ListCertificates`
- `acm:DeleteCertificate`
- `cloudfront:CreateDistribution`
- `cloudfront:GetDistribution`
- `cloudfront:GetDistributionConfig`
- `cloudfront:UpdateDistribution`
- `cloudfront:CreateInvalidation`
- `cloudfront:DeleteDistribution`
- `cloudfront:ListDistributions`
- `ssm:PutParameter`
- `ssm:GetParameter`
- `ssm:GetParameters`
- `ssm:GetParametersByPath`
- `ssm:DescribeParameters`
- `ssm:DeleteParameter`
- `ssm:DeleteParameters`

## Notes
- Route53 hosted zones are currently empty in this account. Terraform currently assumes the public hosted zone already exists and looks it up by root domain name.
- CloudFront certificates must be created in `us-east-1`.
