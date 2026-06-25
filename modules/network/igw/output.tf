##############################################
# Outputs for AWS Internet Gateway Module
##############################################

output "igw_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}

output "igw_arn" {
  description = "ARN of the Internet Gateway"
  value       = aws_internet_gateway.this.arn
}

output "vpc_id" {
  description = "VPC ID this Internet Gateway is attached to"
  value       = aws_internet_gateway.this.vpc_id
}

output "owner_id" {
  description = "Owner account ID of the Internet Gateway"
  value       = aws_internet_gateway.this.owner_id
}

output "tags_all" {
  description = "All tags assigned to the Internet Gateway, including inherited ones"
  value       = aws_internet_gateway.this.tags_all
}
