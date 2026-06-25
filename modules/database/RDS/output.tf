output "db_instance_id" {
  description = "DB instance identifier"
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "DB instance ARN"
  value       = aws_db_instance.this.arn
}

output "endpoint" {
  description = "Connection endpoint"
  value       = aws_db_instance.this.endpoint
}

output "address" {
  description = "DNS address"
  value       = aws_db_instance.this.address
}

output "port" {
  description = "Port"
  value       = aws_db_instance.this.port
}

output "db_subnet_group_name" {
  description = "DB subnet group name"
  value       = local.effective_db_subnet_group_name
}
