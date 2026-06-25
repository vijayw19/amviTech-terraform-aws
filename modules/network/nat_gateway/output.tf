##############################################
# NAT Gateway Outputs
##############################################

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.this.id
}

output "nat_gateway_public_ip" {
  description = "Elastic IP (public IP) associated with NAT Gateway"
  value       = try(aws_nat_gateway.this.public_ip, null)
}

output "network_interface_id" {
  description = "The ID of the network interface associated with NAT Gateway"
  value       = aws_nat_gateway.this.network_interface_id
}

output "association_id" {
  description = "Association ID of the Elastic IP"
  value       = try(aws_nat_gateway.this.association_id, null)
}

output "allocation_id" {
  description = "Allocation ID (either existing or created)"
  value       = var.create_eip ? aws_eip.nat[0].id : var.allocation_id
}

output "tags_all" {
  description = "All tags including inherited provider-level tags"
  value       = aws_nat_gateway.this.tags_all
}
