##############################################
# Service: NAT Gateway Usage
##############################################

module "nat_gateway_public" {
  source = "../../modules/network/nat-gateway"

  nat_gateway_name = "amvitech-nat-public-dev"
  subnet_id        = "subnet-0abc123456789def"
  connectivity_type = "public"
  create_eip        = true
  depends_on_resources = [aws_internet_gateway.main]

  common_tags = var.common_tags
}

module "nat_gateway_private" {
  source = "../../modules/network/nat-gateway"

  nat_gateway_name  = "amvitech-nat-private-dev"
  subnet_id         = "subnet-0xyz987654321abc"
  connectivity_type = "private"
  private_ip        = "10.0.3.10"
  secondary_private_ip_address_count = 3

  common_tags = var.common_tags
}
