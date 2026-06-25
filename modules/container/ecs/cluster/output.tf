##############################################
# Outputs for AWS ECS Cluster Module
##############################################

output "cluster_id" {
  description = "ECS cluster ID"
  value       = aws_ecs_cluster.this.id
}

output "cluster_arn" {
  description = "ECS cluster ARN"
  value       = aws_ecs_cluster.this.arn
}

output "cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.this.name
}

output "capacity_providers_id" {
  description = "ID of the capacity providers association (if enabled)"
  value       = try(aws_ecs_cluster_capacity_providers.this[0].id, null)
}
