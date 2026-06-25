##############################################
# AWS NAT Gateway Module
# Author: Vijay Yadav
##############################################

# Optional EIP Creation
resource "aws_eip" "nat" {
  count = var.create_eip && var.connectivity_type == "public" ? 1 : 0
  vpc   = true

  tags = merge(
    {
      Name = "${var.nat_gateway_name}-eip"
    },
    var.common_tags
  )
}

resource "aws_nat_gateway" "this" {
  allocation_id                    = var.allocation_id != null ? var.allocation_id : (var.create_eip ? aws_eip.nat[0].id : null)
  connectivity_type                 = var.connectivity_type
  private_ip                        = var.private_ip
  region                            = var.region
  subnet_id                         = var.subnet_id
  secondary_allocation_ids          = var.secondary_allocation_ids
  secondary_private_ip_address_count = var.secondary_private_ip_address_count
  secondary_private_ip_addresses    = var.secondary_private_ip_addresses

  tags = merge(
    {
      Name = var.nat_gateway_name
    },
    var.tags,
    var.common_tags
  )

  depends_on = var.depends_on_resources
}
