##############################################
# Outputs for AWS Route Table Module
##############################################

output "route_table_id" {
  description = "ID of the route table"
  value       = aws_route_table.this.id
}

output "route_table_arn" {
  description = "ARN of the route table"
  value       = aws_route_table.this.arn
}

output "owner_id" {
  description = "Owner account ID of the route table"
  value       = aws_route_table.this.owner_id
}

output "tags_all" {
  description = "All tags associated with this route table"
  value       = aws_route_table.this.tags_all
}
