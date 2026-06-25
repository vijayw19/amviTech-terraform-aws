module "rds_instances" {
  source  = "../../modules/database/rds"
  for_each = var.rds_instances

  identifier     = each.value.identifier
  engine         = each.value.engine
  engine_version = lookup(each.value, "engine_version", null)
  instance_class = each.value.instance_class

  db_name   = lookup(each.value, "db_name", null)
  username  = each.value.username
  password  = lookup(each.value, "password", null)

  manage_master_user_password   = lookup(each.value, "manage_master_user_password", true)
  master_user_secret_kms_key_id = lookup(each.value, "master_user_secret_kms_key_id", null)

  allocated_storage          = lookup(each.value, "allocated_storage", 20)
  storage_type               = lookup(each.value, "storage_type", "gp3")
  enable_storage_autoscaling = lookup(each.value, "enable_storage_autoscaling", false)
  max_allocated_storage      = lookup(each.value, "max_allocated_storage", null)

  storage_encrypted = lookup(each.value, "storage_encrypted", true)
  kms_key_id         = lookup(each.value, "kms_key_id", null)
  iops               = lookup(each.value, "iops", null)
  storage_throughput = lookup(each.value, "storage_throughput", null)

  port = lookup(each.value, "port", null)

  vpc_security_group_ids = lookup(each.value, "vpc_security_group_ids", [])
  publicly_accessible    = lookup(each.value, "publicly_accessible", false)
  multi_az               = lookup(each.value, "multi_az", false)
  availability_zone      = lookup(each.value, "availability_zone", null)
  network_type           = lookup(each.value, "network_type", null)

  create_db_subnet_group       = lookup(each.value, "create_db_subnet_group", true)
  subnet_ids                   = lookup(each.value, "subnet_ids", [])
  db_subnet_group_name         = lookup(each.value, "db_subnet_group_name", null)
  db_subnet_group_description  = lookup(each.value, "db_subnet_group_description", "RDS subnet group managed by Terraform")

  create_db_parameter_group     = lookup(each.value, "create_db_parameter_group", false)
  parameter_group_family        = lookup(each.value, "parameter_group_family", null)
  parameter_group_name          = lookup(each.value, "parameter_group_name", null)
  db_parameter_group_name       = lookup(each.value, "db_parameter_group_name", null)
  parameters                    = lookup(each.value, "parameters", [])

  enable_backups           = lookup(each.value, "enable_backups", true)
  backup_retention_period  = lookup(each.value, "backup_retention_period", 7)
  backup_window            = lookup(each.value, "backup_window", null)
  maintenance_window       = lookup(each.value, "maintenance_window", null)

  deletion_protection      = lookup(each.value, "deletion_protection", true)
  skip_final_snapshot      = lookup(each.value, "skip_final_snapshot", true)
  final_snapshot_identifier = lookup(each.value, "final_snapshot_identifier", null)

  enable_enhanced_monitoring = lookup(each.value, "enable_enhanced_monitoring", false)
  monitoring_interval        = lookup(each.value, "monitoring_interval", 60)
  monitoring_role_arn        = lookup(each.value, "monitoring_role_arn", null)

  enable_cloudwatch_logs_exports = lookup(each.value, "enable_cloudwatch_logs_exports", false)
  cloudwatch_logs_exports         = lookup(each.value, "cloudwatch_logs_exports", [])

  enable_performance_insights          = lookup(each.value, "enable_performance_insights", false)
  performance_insights_kms_key_id       = lookup(each.value, "performance_insights_kms_key_id", null)
  performance_insights_retention_period = lookup(each.value, "performance_insights_retention_period", null)

  enable_iam_db_auth              = lookup(each.value, "enable_iam_db_auth", false)
  apply_immediately               = lookup(each.value, "apply_immediately", false)
  auto_minor_version_upgrade      = lookup(each.value, "auto_minor_version_upgrade", true)
  allow_major_version_upgrade     = lookup(each.value, "allow_major_version_upgrade", false)

  tags = merge(var.common_tags, lookup(each.value, "tags", {}))
}
