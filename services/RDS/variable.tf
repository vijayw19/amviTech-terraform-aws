variable "rds_instances" {
  description = "Map of RDS instance definitions."
  type = map(object({
    identifier     = string
    engine         = string
    engine_version = optional(string)
    instance_class = string

    db_name   = optional(string)
    username  = string
    password  = optional(string)

    manage_master_user_password   = optional(bool, true)
    master_user_secret_kms_key_id = optional(string)

    allocated_storage          = optional(number, 20)
    storage_type               = optional(string, "gp3")
    enable_storage_autoscaling = optional(bool, false)
    max_allocated_storage      = optional(number)

    storage_encrypted = optional(bool, true)
    kms_key_id         = optional(string)
    iops               = optional(number)
    storage_throughput = optional(number)

    port = optional(number)

    vpc_security_group_ids = optional(list(string), [])
    publicly_accessible    = optional(bool, false)
    multi_az               = optional(bool, false)
    availability_zone      = optional(string)
    network_type           = optional(string)

    create_db_subnet_group      = optional(bool, true)
    subnet_ids                  = optional(list(string), [])
    db_subnet_group_name        = optional(string)
    db_subnet_group_description = optional(string)

    create_db_parameter_group = optional(bool, false)
    parameter_group_family    = optional(string)
    parameter_group_name      = optional(string)
    db_parameter_group_name   = optional(string)
    parameters = optional(list(object({
      name         = string
      value        = string
      apply_method = optional(string)
    })), [])

    enable_backups          = optional(bool, true)
    backup_retention_period = optional(number, 7)
    backup_window           = optional(string)
    maintenance_window      = optional(string)

    deletion_protection       = optional(bool, true)
    skip_final_snapshot       = optional(bool, true)
    final_snapshot_identifier = optional(string)

    enable_enhanced_monitoring = optional(bool, false)
    monitoring_interval        = optional(number, 60)
    monitoring_role_arn        = optional(string)

    enable_cloudwatch_logs_exports = optional(bool, false)
    cloudwatch_logs_exports         = optional(list(string), [])

    enable_performance_insights          = optional(bool, false)
    performance_insights_kms_key_id       = optional(string)
    performance_insights_retention_period = optional(number)

    enable_iam_db_auth          = optional(bool, false)
    apply_immediately           = optional(bool, false)
    auto_minor_version_upgrade  = optional(bool, true)
    allow_major_version_upgrade = optional(bool, false)

    tags = optional(map(string), {})
  }))
}

variable "common_tags" {
  description = "Common tags applied to all instances"
  type        = map(string)
  default     = {}
}
