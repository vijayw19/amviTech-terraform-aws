##############################################
# Variables for AWS ECS Cluster Module
# Author: Vijay Yadav
##############################################

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "tags" {
  description = "Tags to assign to ECS cluster resources"
  type        = map(string)
  default     = {}
}

# ----- Cluster Settings -----
# Example:
# settings = [
#   { name = "containerInsights", value = "enabled" }
# ]
variable "settings" {
  description = "ECS cluster settings"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

# ----- Cluster configuration (optional) -----
# Supports:
# configuration = {
#   execute_command_configuration = {
#     kms_key_id = "arn:aws:kms:..."
#     logging    = "DEFAULT" # NONE | DEFAULT | OVERRIDE
#     log_configuration = {
#       cloud_watch_encryption_enabled = true
#       cloud_watch_log_group_name     = "/ecs/exec"
#       s3_bucket_name                 = "my-bucket"
#       s3_bucket_encryption_enabled   = true
#       s3_key_prefix                  = "ecs-exec/"
#     }
#   }
# }
variable "configuration" {
  description = "Optional ECS cluster configuration (ECS Exec)"
  type = object({
    execute_command_configuration = optional(object({
      kms_key_id = optional(string)
      logging    = optional(string)

      log_configuration = optional(object({
        cloud_watch_encryption_enabled = optional(bool)
        cloud_watch_log_group_name     = optional(string)

        s3_bucket_name               = optional(string)
        s3_bucket_encryption_enabled = optional(bool)
        s3_key_prefix                = optional(string)
      }))
    }))
  })
  default = null
}

# ----- Service Connect defaults (optional) -----
# service_connect_defaults = { namespace = "arn:aws:servicediscovery:..." }
variable "service_connect_defaults" {
  description = "Optional Service Connect defaults"
  type = object({
    namespace = string
  })
  default = null
}

# ----- Capacity Providers (optional) -----
variable "enable_capacity_providers" {
  description = "Whether to manage capacity providers for the cluster"
  type        = bool
  default     = true
}

variable "capacity_providers" {
  description = "List of capacity providers (e.g. FARGATE, FARGATE_SPOT)"
  type        = list(string)
  default     = ["FARGATE", "FARGATE_SPOT"]
}

variable "default_capacity_provider_strategy" {
  description = "Default capacity provider strategy"
  type = list(object({
    capacity_provider = string
    base              = optional(number)
    weight            = optional(number)
  }))
  default = []
}
