##############################################
# AWS ECS Cluster Module
# Author: Vijay Yadav
##############################################

resource "aws_ecs_cluster" "this" {
  name = var.cluster_name

  # ---- Optional Cluster Configuration ----
  # Supports execute_command_configuration (ECS Exec), etc.
  dynamic "configuration" {
    for_each = var.configuration == null ? [] : [var.configuration]
    content {
      dynamic "execute_command_configuration" {
        for_each = try(configuration.value.execute_command_configuration, null) == null ? [] : [configuration.value.execute_command_configuration]
        content {
          kms_key_id = try(execute_command_configuration.value.kms_key_id, null)
          logging    = try(execute_command_configuration.value.logging, null)

          dynamic "log_configuration" {
            for_each = try(execute_command_configuration.value.log_configuration, null) == null ? [] : [execute_command_configuration.value.log_configuration]
            content {
              cloud_watch_encryption_enabled = try(log_configuration.value.cloud_watch_encryption_enabled, null)
              cloud_watch_log_group_name     = try(log_configuration.value.cloud_watch_log_group_name, null)

              s3_bucket_name                 = try(log_configuration.value.s3_bucket_name, null)
              s3_bucket_encryption_enabled   = try(log_configuration.value.s3_bucket_encryption_enabled, null)
              s3_key_prefix                  = try(log_configuration.value.s3_key_prefix, null)
            }
          }
        }
      }
    }
  }

  # ---- Cluster Settings (e.g., Container Insights) ----
  dynamic "setting" {
    for_each = var.settings
    content {
      name  = setting.value.name
      value = setting.value.value
    }
  }

  # ---- Service Connect Defaults (optional) ----
  dynamic "service_connect_defaults" {
    for_each = var.service_connect_defaults == null ? [] : [var.service_connect_defaults]
    content {
      namespace = service_connect_defaults.value.namespace
    }
  }

  # ---- Tags ----
  tags = merge(var.tags, {
    Name = var.cluster_name
  })
}

##############################################
# ECS Service-Linked Role (required for some ECS operations)
##############################################
#resource "aws_iam_service_linked_role" "ecs" {
#  aws_service_name = "ecs.amazonaws.com"
#  lifecycle {
#    prevent_destroy = true
#  }
#}


##############################################
# Optional: ECS Cluster Capacity Providers
# (Recommended approach on AWS provider v5+)
##############################################
resource "aws_ecs_cluster_capacity_providers" "this" {
  count = var.enable_capacity_providers ? 1 : 0

  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = var.capacity_providers

  dynamic "default_capacity_provider_strategy" {
    for_each = var.default_capacity_provider_strategy
    content {
      capacity_provider = default_capacity_provider_strategy.value.capacity_provider
      base              = try(default_capacity_provider_strategy.value.base, null)
      weight            = try(default_capacity_provider_strategy.value.weight, null)
    }
  }
  #depends_on = [aws_iam_service_linked_role.ecs]
}
