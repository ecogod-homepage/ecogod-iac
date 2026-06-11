resource "aws_ssm_parameter" "placeholder" {
  for_each = toset(var.parameter_names)

  name  = each.value
  type  = "String"
  value = "REPLACE_ME"
  tags  = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}
