module "vpc" {
  source = "../../modules/network/vpc"

  vpc_name   = var.vpc_name
  cidr_block = var.vpc_cidr
  region     = var.aws_region

  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_network_address_usage_metrics = false

  instance_tenancy = "default"

  # Optional IPAM Example (comment out if not used)
  # ipv4_ipam_pool_id   = "ipam-pool-1234567890"
  # ipv4_netmask_length = 16

  assign_generated_ipv6_cidr_block = false

  tags = var.common_tags
}
