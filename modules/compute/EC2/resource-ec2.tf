##############################################
# EC2 Instance (Highly Customizable)
##############################################

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  availability_zone      = var.availability_zone
  subnet_id              = var.subnet_id
  key_name               = var.key_name != null && var.key_name != "" ? var.key_name : null

  # Networking
  associate_public_ip_address = var.associate_public_ip_address
  ipv6_address_count          = var.ipv6_address_count
  ipv6_addresses              = var.ipv6_addresses
  private_ip                  = var.private_ip
  secondary_private_ips       = var.secondary_private_ips
  vpc_security_group_ids      = var.vpc_security_group_ids
  security_groups             = var.security_groups

  # Storage
  ebs_optimized          = var.ebs_optimized
  disable_api_termination = var.disable_api_termination
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  monitoring             = var.monitoring
  source_dest_check      = var.source_dest_check
  tenancy                = var.tenancy
  host_id                = var.host_id
  placement_group        = var.placement_group
  hibernation            = var.hibernation
  cpu_core_count         = var.cpu_core_count
  cpu_threads_per_core   = var.cpu_threads_per_core

  # Root Block Device
  root_block_device {
    delete_on_termination = var.root_delete_on_termination
    encrypted             = var.root_encrypted
    iops                  = var.root_iops
    kms_key_id            = var.root_kms_key_id
    throughput            = var.root_throughput
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
  }


  # Additional EBS Volumes
  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices
    content {
      device_name           = ebs_block_device.value.device_name
      volume_size           = ebs_block_device.value.volume_size
      volume_type           = ebs_block_device.value.volume_type
      iops                  = lookup(ebs_block_device.value, "iops", null)
      throughput            = lookup(ebs_block_device.value, "throughput", null)
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", true)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
    }
  }

  # Ephemeral (Instance Store) Volumes
  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_devices
    content {
      device_name  = ephemeral_block_device.value.device_name
      virtual_name = ephemeral_block_device.value.virtual_name
    }
  }

  # Metadata & User Data
  user_data                   = var.user_data
  user_data_replace_on_change = var.user_data_replace_on_change
  metadata_options {
    http_endpoint               = var.metadata_http_endpoint
    http_put_response_hop_limit = var.metadata_http_put_response_hop_limit
    http_tokens                 = var.metadata_http_tokens
    instance_metadata_tags      = var.metadata_instance_tags
  }

  enclave_options {
    enabled = var.enclave_enabled
  }

  # Credit Specifications (for burstable instances like t2/t3)
  credit_specification {
    cpu_credits = var.cpu_credits
  }

  # Lifecycle
    lifecycle {
    create_before_destroy = false
    prevent_destroy       = false
    ignore_changes        = []
  }


  # Tags
  tags        = var.tags
  volume_tags = var.volume_tags
}
