##############################################
# AWS Network ACL Module
# Author: Vijay Yadav
##############################################

resource "aws_network_acl" "this" {
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids
  region     = var.region

  # --------------------
  # Dynamic Ingress Rules
  # --------------------
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      rule_no         = lookup(ingress.value, "rule_no", null)
      protocol        = lookup(ingress.value, "protocol", "-1")
      action          = lookup(ingress.value, "action", "allow")
      cidr_block      = lookup(ingress.value, "cidr_block", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      from_port       = lookup(ingress.value, "from_port", 0)
      to_port         = lookup(ingress.value, "to_port", 0)
      icmp_type       = lookup(ingress.value, "icmp_type", 0)
      icmp_code       = lookup(ingress.value, "icmp_code", 0)
    }
  }

  # --------------------
  # Dynamic Egress Rules
  # --------------------
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      rule_no         = lookup(egress.value, "rule_no", null)
      protocol        = lookup(egress.value, "protocol", "-1")
      action          = lookup(egress.value, "action", "allow")
      cidr_block      = lookup(egress.value, "cidr_block", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      from_port       = lookup(egress.value, "from_port", 0)
      to_port         = lookup(egress.value, "to_port", 0)
      icmp_type       = lookup(egress.value, "icmp_type", 0)
      icmp_code       = lookup(egress.value, "icmp_code", 0)
    }
  }

  tags = merge(
    {
      Name = var.nacl_name
    },
    var.tags,
    var.common_tags
  )
}
