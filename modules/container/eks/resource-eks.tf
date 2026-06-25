#########################################
# AWS VPC Module
# Author: Vijay Yadav
#########################################

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  instance_tenancy = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  # ---- IPv4 IPAM Options ----
  ipv4_ipam_pool_id   = var.ipv4_ipam_pool_id
  ipv4_netmask_length = var.ipv4_netmask_length

  # ---- IPv6 Options ----
  assign_generated_ipv6_cidr_block           = var.assign_generated_ipv6_cidr_block
  ipv6_ipam_pool_id                          = var.ipv6_ipam_pool_id
  ipv6_cidr_block                            = var.ipv6_cidr_block
  ipv6_netmask_length                        = var.ipv6_netmask_length
  ipv6_cidr_block_network_border_group       = var.ipv6_cidr_block_network_border_group

  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics

  # ---- Tags ----
  tags = merge(var.tags, {
    Name = var.vpc_name
  })
}
