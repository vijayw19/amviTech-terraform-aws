variable "lambdas" {
  type = map(object({
    function_name = string
    runtime       = string
    handler       = string
    role_arn      = string

    use_s3_package    = optional(bool, true)
    s3_bucket         = optional(string)
    s3_key            = optional(string)
    s3_object_version = optional(string)

    use_local_zip    = optional(bool, false)
    filename         = optional(string)
    source_code_hash = optional(string)

    memory_size    = optional(number, 256)
    timeout        = optional(number, 30)
    architectures  = optional(list(string), ["x86_64"])
    publish        = optional(bool, false)

    enable_reserved_concurrency    = optional(bool, false)
    reserved_concurrent_executions = optional(number)

    ephemeral_storage_size = optional(number, 512)

    environment_variables = optional(map(string), {})

    enable_vpc_config  = optional(bool, false)
    subnet_ids         = optional(list(string), [])
    security_group_ids = optional(list(string), [])

    enable_xray = optional(bool, false)

    enable_dead_letter     = optional(bool, false)
    dead_letter_target_arn = optional(string)

    create_log_group      = optional(bool, true)
    log_retention_in_days = optional(number, 14)
    log_kms_key_id        = optional(string)

    enable_function_url     = optional(bool, false)
    function_url_auth_type  = optional(string, "NONE")
    enable_function_url_cors = optional(bool, false)
    function_url_cors_allow_origins  = optional(list(string), ["*"])
    function_url_cors_allow_methods  = optional(list(string), ["*"])
    function_url_cors_allow_headers  = optional(list(string), ["*"])
    function_url_cors_expose_headers = optional(list(string), [])
    function_url_cors_max_age        = optional(number, 0)
    function_url_cors_allow_credentials = optional(bool, false)

    tags = optional(map(string), {})
    description = optional(string)
  }))
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
