##############################################
# Service: Network ACL (Reusable)
# Author: Vijay Yadav
##############################################

module "network_acl" {
  source = "../../modules/network/network_acl"

  nacl_name   = var.nacl_final_name
  vpc_id      = var.vpc_id
  subnet_ids  = var.subnet_ids
  region      = var.region

  ingress_rules = var.ingress_rules
  egress_rules  = var.egress_rules

  common_tags = var.common_tags
}
