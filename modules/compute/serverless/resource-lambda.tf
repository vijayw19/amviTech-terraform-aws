##############################################
# Optional CloudWatch Log Group (recommended)
##############################################
resource "aws_cloudwatch_log_group" "this" {
  count = var.create_log_group ? 1 : 0

  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = var.log_kms_key_id

  tags = var.tags
}

##############################################
# Lambda Function
##############################################
resource "aws_lambda_function" "this" {
  function_name = var.function_name
  description   = var.description

  role    = var.role_arn
  handler = var.handler
  runtime = var.runtime

  # Packaging: prefer S3 for CI/CD, but local file is also supported
  filename         = var.use_local_zip ? var.filename : null
  s3_bucket        = var.use_s3_package ? var.s3_bucket : null
  s3_key           = var.use_s3_package ? var.s3_key : null
  s3_object_version = var.use_s3_package ? var.s3_object_version : null

  source_code_hash = var.use_local_zip ? var.source_code_hash : null

  memory_size = var.memory_size
  timeout     = var.timeout

  architectures = var.architectures

  publish = var.publish

  reserved_concurrent_executions = var.enable_reserved_concurrency ? var.reserved_concurrent_executions : null

  ephemeral_storage {
    size = var.ephemeral_storage_size
  }

  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [1] : []
    content {
      variables = var.environment_variables
    }
  }

  dynamic "vpc_config" {
    for_each = var.enable_vpc_config ? [1] : []
    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = var.security_group_ids
    }
  }

  tracing_config {
    mode = var.enable_xray ? "Active" : "PassThrough"
  }

  dynamic "dead_letter_config" {
    for_each = var.enable_dead_letter ? [1] : []
    content {
      target_arn = var.dead_letter_target_arn
    }
  }

  tags = var.tags
}

##############################################
# Optional Function URL (nice for quick testing)
##############################################
resource "aws_lambda_function_url" "this" {
  count = var.enable_function_url ? 1 : 0

  function_name      = aws_lambda_function.this.function_name
  authorization_type = var.function_url_auth_type # NONE or AWS_IAM

  dynamic "cors" {
    for_each = var.enable_function_url_cors ? [1] : []
    content {
      allow_origins = var.function_url_cors_allow_origins
      allow_methods = var.function_url_cors_allow_methods
      allow_headers = var.function_url_cors_allow_headers
      expose_headers = var.function_url_cors_expose_headers
      max_age       = var.function_url_cors_max_age
      allow_credentials = var.function_url_cors_allow_credentials
    }
  }
}
