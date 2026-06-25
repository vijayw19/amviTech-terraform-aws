##############################################
# Optional DB Subnet Group
##############################################
resource "aws_db_subnet_group" "this" {
  count = var.create_db_subnet_group ? 1 : 0

  name        = var.db_subnet_group_name != null ? var.db_subnet_group_name : "${var.identifier}-subnet-group"
  description = var.db_subnet_group_description
  subnet_ids  = var.subnet_ids

  tags = var.tags
}

locals {
  effective_db_subnet_group_name = var.create_db_subnet_group ? aws_db_subnet_group.this[0].name : var.db_subnet_group_name
}

##############################################
# Optional DB Parameter Group
##############################################
resource "aws_db_parameter_group" "this" {
  count = var.create_db_parameter_group ? 1 : 0

  name        = var.db_parameter_group_name != null ? var.db_parameter_group_name : "${var.identifier}-param-group"
  family      = var.parameter_group_family
  description = var.db_parameter_group_description

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", "immediate")
    }
  }

  tags = var.tags
}

locals {
  effective_parameter_group_name = var.create_db_parameter_group ? aws_db_parameter_group.this[0].name : var.parameter_group_name
}

##############################################
# RDS DB Instance
##############################################
resource "aws_db_instance" "this" {
  identifier = var.identifier

  # Engine
  engine         = var.engine
  engine_version = var.engine_version

  # Instance sizing
  instance_class = var.instance_class

  # Storage
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.enable_storage_autoscaling ? var.max_allocated_storage : null
  storage_type          = var.storage_type
  storage_encrypted     = var.storage_encrypted
  kms_key_id            = var.storage_encrypted ? var.kms_key_id : null
  iops                  = var.iops
  storage_throughput    = var.storage_throughput

  # Database
  db_name  = var.db_name
  username = var.username

  # Password options (choose one approach)
  password                   = var.manage_master_user_password ? null : var.password
  manage_master_user_password = var.manage_master_user_password
  master_user_secret_kms_key_id = var.manage_master_user_password ? var.master_user_secret_kms_key_id : null

  port = var.port

  # Networking
  db_subnet_group_name   = local.effective_db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids
  publicly_accessible    = var.publicly_accessible
  multi_az               = var.multi_az

  # Availability / DNS settings
  availability_zone     = var.availability_zone
  network_type          = var.network_type

  # Maintenance & backups
  backup_retention_period = var.enable_backups ? var.backup_retention_period : 0
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  # Updates / deletion behavior
  apply_immediately      = var.apply_immediately
  deletion_protection    = var.deletion_protection
  skip_final_snapshot    = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : var.final_snapshot_identifier

  # Monitoring / logs
  monitoring_interval = var.enable_enhanced_monitoring ? var.monitoring_interval : 0
  monitoring_role_arn = var.enable_enhanced_monitoring ? var.monitoring_role_arn : null

  enabled_cloudwatch_logs_exports = var.enable_cloudwatch_logs_exports ? var.cloudwatch_logs_exports : null

  performance_insights_enabled          = var.enable_performance_insights
  performance_insights_kms_key_id       = var.enable_performance_insights ? var.performance_insights_kms_key_id : null
  performance_insights_retention_period = var.enable_performance_insights ? var.performance_insights_retention_period : null

  # Auth
  iam_database_authentication_enabled = var.enable_iam_db_auth

  # Parameter group (optional)
  parameter_group_name = local.effective_parameter_group_name

  # Minor helpful defaults
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  allow_major_version_upgrade = var.allow_major_version_upgrade

  # Tags
  tags = var.tags
}
