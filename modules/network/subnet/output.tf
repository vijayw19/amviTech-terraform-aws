##############################################
# Outputs for AWS Subnet Module
##############################################

output "subnet_id" {
  description = "ID of the subnet"
  value       = aws_subnet.this.id
}

output "subnet_arn" {
  description = "ARN of the subnet"
  value       = aws_subnet.this.arn
}

output "ipv6_cidr_block_association_id" {
  description = "IPv6 CIDR block association ID"
  value       = aws_subnet.this.ipv6_cidr_block_association_id
}

output "owner_id" {
  description = "Owner account ID"
  value       = aws_subnet.this.owner_id
}

output "availability_zone" {
  description = "Availability zone of the subnet"
  value       = aws_subnet.this.availability_zone
}

output "availability_zone_id" {
  description = "Availability zone ID of the subnet"
  value       = aws_subnet.this.availability_zone_id
}

output "tags_all" {
  description = "All tags applied to the subnet"
  value       = aws_subnet.this.tags_all
}
