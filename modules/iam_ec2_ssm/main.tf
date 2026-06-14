data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ssm_read" {
  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath"
    ]
    resources = ["arn:aws:ssm:*:*:parameter${var.ssm_parameter_prefix}*"]
  }
}

data "aws_iam_policy_document" "asset_write" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObject"
    ]
    resources = ["${var.asset_bucket_arn}/${var.asset_object_prefix}*"]
  }
}

resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "ssm_read" {
  name   = "${var.role_name}-ssm-read"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.ssm_read.json
}

resource "aws_iam_role_policy" "asset_write" {
  name   = "${var.role_name}-asset-write"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.asset_write.json
}

resource "aws_iam_instance_profile" "this" {
  name = var.instance_profile_name
  role = aws_iam_role.this.name
}
