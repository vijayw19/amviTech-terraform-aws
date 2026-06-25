module "subnets" {
  source = "../../modules/network/subnet"

  for_each = var.subnets

  subnet_name               = each.value.subnet_name
  vpc_id                    = var.vpc_id
  cidr_block                = each.value.cidr_block
  availability_zone         = each.value.availability_zone
  map_public_ip_on_launch   = lookup(each.value, "map_public_ip_on_launch", false)
  tags                      = merge(var.common_tags, { Name = each.value.subnet_name })
}
