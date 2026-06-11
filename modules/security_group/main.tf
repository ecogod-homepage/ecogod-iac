resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "cidr" {
  for_each = {
    for idx, rule in var.ingress_rules : idx => rule
    if try(length(rule.cidr_blocks), 0) > 0
  }

  security_group_id = aws_security_group.this.id
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr_blocks[0]
}

resource "aws_vpc_security_group_ingress_rule" "sg" {
  for_each = {
    for idx, rule in var.ingress_rules : idx => rule
    if try(rule.source_security_group_id, null) != null
  }

  security_group_id            = aws_security_group.this.id
  description                  = each.value.description
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.protocol
  referenced_security_group_id = each.value.source_security_group_id
}
