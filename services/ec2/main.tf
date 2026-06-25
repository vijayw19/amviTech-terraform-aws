module "ec2_instances" {
  source = "../../modules/compute/EC2"

  for_each = var.ec2_instances

  # Required
  ami_id        = each.value.ami_id
  instance_type = each.value.instance_type
  subnet_id     = each.value.subnet_id
  key_name      = each.value.key_name

  # Optional
  associate_public_ip_address = lookup(each.value, "associate_public_ip_address", false)
  vpc_security_group_ids      = lookup(each.value, "vpc_security_group_ids", [])
  private_ip                  = lookup(each.value, "private_ip", null)

  root_volume_size            = lookup(each.value, "root_volume_size", 8)
  root_volume_type            = lookup(each.value, "root_volume_type", "gp3")
  root_delete_on_termination  = lookup(each.value, "root_delete_on_termination", true)
  root_encrypted              = lookup(each.value, "root_encrypted", false)

  ebs_block_devices           = lookup(each.value, "ebs_block_devices", [])

  user_data                   = lookup(each.value, "user_data", null)
  user_data_replace_on_change = lookup(each.value, "user_data_replace_on_change", false)

  tags                        = merge(var.common_tags, lookup(each.value, "tags", {}))
}
