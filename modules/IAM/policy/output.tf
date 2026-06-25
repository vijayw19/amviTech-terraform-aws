#########################################
# Outputs for AWS VPC Module
#########################################

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.this.arn
}

output "vpc_cidr_block" {
  description = "IPv4 CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "ipv6_cidr_block" {
  description = "IPv6 CIDR block assigned to the VPC"
  value       = aws_vpc.this.ipv6_cidr_block
}

output "default_route_table_id" {
  description = "Default route table ID"
  value       = aws_vpc.this.default_route_table_id
}

output "default_network_acl_id" {
  description = "Default Network ACL ID"
  value       = aws_vpc.this.default_network_acl_id
}

output "default_security_group_id" {
  description = "Default Security Group ID"
  value       = aws_vpc.this.default_security_group_id
}

output "main_route_table_id" {
  description = "Main route table ID for the VPC"
  value       = aws_vpc.this.main_route_table_id
}

output "owner_id" {
  description = "Owner Account ID of the VPC"
  value       = aws_vpc.this.owner_id
}

output "tags_all" {
  description = "All tags including provider default tags"
  value       = aws_vpc.this.tags_all
}
