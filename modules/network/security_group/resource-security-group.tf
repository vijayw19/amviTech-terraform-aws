##############################################
# AWS Security Group Module
# Author: Vijay Yadav
##############################################

resource "aws_security_group" "this" {
  # ---- Basic Info ----
  name        = var.sg_name
  name_prefix = var.name_prefix
  description = var.description
  vpc_id      = var.vpc_id
  region      = var.region

  # ---- Lifecycle Controls ----
  revoke_rules_on_delete = var.revoke_rules_on_delete

  # ---- Optional Inline Ingress Rules ----
  # Note: Inline rules are generally discouraged for multi-CIDR security groups.
  # Use dedicated aws_vpc_security_group_ingress_rule & egress_rule resources instead.
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port         = lookup(ingress.value, "from_port", 0)
      to_port           = lookup(ingress.value, "to_port", 0)
      protocol          = lookup(ingress.value, "protocol", "-1")
      cidr_blocks       = lookup(ingress.value, "cidr_blocks", [])
      ipv6_cidr_blocks  = lookup(ingress.value, "ipv6_cidr_blocks", [])
      prefix_list_ids   = lookup(ingress.value, "prefix_list_ids", [])
      description       = lookup(ingress.value, "description", null)
      security_groups   = lookup(ingress.value, "security_groups", [])
    }
  }

  # ---- Optional Inline Egress Rules ----
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port         = lookup(egress.value, "from_port", 0)
      to_port           = lookup(egress.value, "to_port", 0)
      protocol          = lookup(egress.value, "protocol", "-1")
      cidr_blocks       = lookup(egress.value, "cidr_blocks", [])
      ipv6_cidr_blocks  = lookup(egress.value, "ipv6_cidr_blocks", [])
      prefix_list_ids   = lookup(egress.value, "prefix_list_ids", [])
      description       = lookup(egress.value, "description", null)
      security_groups   = lookup(egress.value, "security_groups", [])
    }
  }

  # ---- Tags ----
  tags = merge(var.tags, {
    Name = var.sg_name
  })

  # ---- Lifecycle ----
  lifecycle {
    create_before_destroy = var.create_before_destroy
  }

  # ---- Timeouts ----
  timeouts {
    create = var.timeout_create
    delete = var.timeout_delete
  }
}
