##############################################
# Outputs for AWS Security Group Module
##############################################

output "sg_id" {
  description = "The ID of the created security group"
  value       = aws_security_group.this.id
}

output "sg_arn" {
  description = "ARN of the security group"
  value       = aws_security_group.this.arn
}

output "vpc_id" {
  description = "VPC ID where this SG belongs"
  value       = aws_security_group.this.vpc_id
}

output "owner_id" {
  description = "AWS Account ID that owns this SG"
  value       = aws_security_group.this.owner_id
}

output "tags_all" {
  description = "All tags including provider defaults"
  value       = aws_security_group.this.tags_all
}
