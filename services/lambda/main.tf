module "lambdas" {
  source  = "../../modules/compute/serverless"
  for_each = var.lambdas

  function_name = each.value.function_name
  description   = lookup(each.value, "description", null)

  runtime = each.value.runtime
  handler = each.value.handler
  role_arn = each.value.role_arn

  use_s3_package      = lookup(each.value, "use_s3_package", true)
  s3_bucket           = lookup(each.value, "s3_bucket", null)
  s3_key              = lookup(each.value, "s3_key", null)
  s3_object_version   = lookup(each.value, "s3_object_version", null)

  use_local_zip       = lookup(each.value, "use_local_zip", false)
  filename            = lookup(each.value, "filename", null)
  source_code_hash    = lookup(each.value, "source_code_hash", null)

  memory_size = lookup(each.value, "memory_size", 256)
  timeout     = lookup(each.value, "timeout", 30)
  architectures = lookup(each.value, "architectures", ["x86_64"])
  publish = lookup(each.value, "publish", false)

  enable_reserved_concurrency      = lookup(each.value, "enable_reserved_concurrency", false)
  reserved_concurrent_executions   = lookup(each.value, "reserved_concurrent_executions", null)

  ephemeral_storage_size = lookup(each.value, "ephemeral_storage_size", 512)

  environment_variables = lookup(each.value, "environment_variables", {})

  enable_vpc_config  = lookup(each.value, "enable_vpc_config", false)
  subnet_ids         = lookup(each.value, "subnet_ids", [])
  security_group_ids = lookup(each.value, "security_group_ids", [])

  enable_xray        = lookup(each.value, "enable_xray", false)

  enable_dead_letter       = lookup(each.value, "enable_dead_letter", false)
  dead_letter_target_arn   = lookup(each.value, "dead_letter_target_arn", null)

  create_log_group        = lookup(each.value, "create_log_group", true)
  log_retention_in_days   = lookup(each.value, "log_retention_in_days", 14)
  log_kms_key_id          = lookup(each.value, "log_kms_key_id", null)

  enable_function_url              = lookup(each.value, "enable_function_url", false)
  function_url_auth_type           = lookup(each.value, "function_url_auth_type", "NONE")
  enable_function_url_cors         = lookup(each.value, "enable_function_url_cors", false)
  function_url_cors_allow_origins  = lookup(each.value, "function_url_cors_allow_origins", ["*"])
  function_url_cors_allow_methods  = lookup(each.value, "function_url_cors_allow_methods", ["*"])
  function_url_cors_allow_headers  = lookup(each.value, "function_url_cors_allow_headers", ["*"])
  function_url_cors_expose_headers = lookup(each.value, "function_url_cors_expose_headers", [])
  function_url_cors_max_age        = lookup(each.value, "function_url_cors_max_age", 0)
  function_url_cors_allow_credentials = lookup(each.value, "function_url_cors_allow_credentials", false)

  tags = merge(var.common_tags, lookup(each.value, "tags", {}))
}
