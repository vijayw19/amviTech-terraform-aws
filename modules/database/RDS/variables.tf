##############################################
# Core
##############################################
variable "identifier" {
  description = "Unique identifier for the DB instance"
  type        = string
}

variable "engine" {
  description = "Database engine (e.g., postgres, mysql)"
  type        = string
}

variable "engine_version" {
  description = "Engine version (optional)"
  type        = string
  default     = null
}

variable "instance_class" {
  description = "DB instance class (e.g., db.t3.micro)"
  type        = string
}

variable "db_name" {
  description = "Initial database name (optional, engine-specific)"
  type        = string
  default     = null
}

variable "username" {
  description = "Master username"
  type        = string
}

variable "password" {
  description = "Master password (use only if manage_master_user_password=false)"
  type        = string
  default     = null
  sensitive   = true
}

##############################################
# Password management toggle
##############################################
variable "manage_master_user_password" {
  description = "If true, AWS manages the master password in Secrets Manager"
  type        = bool
  default     = true
}

variable "master_user_secret_kms_key_id" {
  description = "KMS key for the generated master secret (optional)"
  type        = string
  default     = null
}

variable "port" {
  description = "DB port"
  type        = number
  default     = null
}

##############################################
# Storage
##############################################
variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type (gp2, gp3, io1, io2)"
  type        = string
  default     = "gp3"
}

variable "enable_storage_autoscaling" {
  description = "Enable storage autoscaling using max_allocated_storage"
  type        = bool
  default     = false
}

variable "max_allocated_storage" {
  description = "Max storage for autoscaling (must be > allocated_storage)"
  type        = number
  default     = null
}

variable "storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key for storage encryption (optional)"
  type        = string
  default     = null
}

variable "iops" {
  description = "IOPS (for io1/io2/gp3 as applicable)"
  type        = number
  default     = null
}

variable "storage_throughput" {
  description = "Storage throughput (gp3)"
  type        = number
  default     = null
}

##############################################
# Networking
##############################################
variable "vpc_security_group_ids" {
  description = "Security group IDs"
  type        = list(string)
  default     = []
}

variable "publicly_accessible" {
  description = "Publicly accessible"
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "availability_zone" {
  description = "AZ for single-AZ deployments (optional)"
  type        = string
  default     = null
}

variable "network_type" {
  description = "Network type (optional, e.g., IPV4)"
  type        = string
  default     = null
}

##############################################
# DB Subnet Group toggle
##############################################
variable "create_db_subnet_group" {
  description = "Create a DB subnet group"
  type        = bool
  default     = true
}

variable "subnet_ids" {
  description = "Subnet IDs for DB subnet group (required when create_db_subnet_group=true)"
  type        = list(string)
  default     = []
}

variable "db_subnet_group_name" {
  description = "Existing DB subnet group name (used when create_db_subnet_group=false)"
  type        = string
  default     = null
}

variable "db_subnet_group_description" {
  description = "Subnet group description"
  type        = string
  default     = "RDS subnet group managed by Terraform"
}

##############################################
# Parameter Group toggle
##############################################
variable "create_db_parameter_group" {
  description = "Create a DB parameter group"
  type        = bool
  default     = false
}

variable "parameter_group_family" {
  description = "Parameter group family (required when create_db_parameter_group=true)"
  type        = string
  default     = null
}

variable "parameter_group_name" {
  description = "Existing parameter group name (used when create_db_parameter_group=false)"
  type        = string
  default     = null
}

variable "db_parameter_group_name" {
  description = "Name for created parameter group"
  type        = string
  default     = null
}

variable "db_parameter_group_description" {
  description = "Parameter group description"
  type        = string
  default     = "RDS parameter group managed by Terraform"
}

variable "parameters" {
  description = "List of DB parameters (only used if create_db_parameter_group=true)"
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string)
  }))
  default = []
}

##############################################
# Backups / Maintenance
##############################################
variable "enable_backups" {
  description = "Enable backups (sets backup_retention_period>0)"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "Backup retention days"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Preferred backup window"
  type        = string
  default     = null
}

variable "maintenance_window" {
  description = "Preferred maintenance window"
  type        = string
  default     = null
}

##############################################
# Delete behavior toggles
##############################################
variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on destroy"
  type        = bool
  default     = true
}

variable "final_snapshot_identifier" {
  description = "Final snapshot identifier (required if skip_final_snapshot=false)"
  type        = string
  default     = null
}

##############################################
# Monitoring / Logs toggles
##############################################
variable "enable_enhanced_monitoring" {
  description = "Enable enhanced monitoring"
  type        = bool
  default     = false
}

variable "monitoring_interval" {
  description = "Enhanced monitoring interval (seconds)"
  type        = number
  default     = 60
}

variable "monitoring_role_arn" {
  description = "IAM role ARN for enhanced monitoring (required if enable_enhanced_monitoring=true)"
  type        = string
  default     = null
}

variable "enable_cloudwatch_logs_exports" {
  description = "Enable CloudWatch log exports"
  type        = bool
  default     = false
}

variable "cloudwatch_logs_exports" {
  description = "List of log types to export (engine-specific)"
  type        = list(string)
  default     = []
}

variable "enable_performance_insights" {
  description = "Enable Performance Insights"
  type        = bool
  default     = false
}

variable "performance_insights_kms_key_id" {
  description = "KMS key for Performance Insights (optional)"
  type        = string
  default     = null
}

variable "performance_insights_retention_period" {
  description = "Retention period for PI (days)"
  type        = number
  default     = null
}

##############################################
# Auth toggles
##############################################
variable "enable_iam_db_auth" {
  description = "Enable IAM Database Authentication"
  type        = bool
  default     = false
}

##############################################
# Misc toggles
##############################################
variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Auto minor version upgrades"
  type        = bool
  default     = true
}

variable "allow_major_version_upgrade" {
  description = "Allow major version upgrades"
  type        = bool
  default     = false
}

##############################################
# Tags
##############################################
variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
