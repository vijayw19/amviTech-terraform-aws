##############################################
# Outputs for Network ACL
##############################################

output "nacl_id" {
  description = "The ID of the Network ACL"
  value       = aws_network_acl.this.id
}

output "nacl_arn" {
  description = "The ARN of the Network ACL"
  value       = aws_network_acl.this.arn
}

output "owner_id" {
  description = "The AWS account ID of the NACL owner"
  value       = aws_network_acl.this.owner_id
}

output "tags_all" {
  description = "All tags assigned to the Network ACL (including inherited tags)"
  value       = aws_network_acl.this.tags_all
}
