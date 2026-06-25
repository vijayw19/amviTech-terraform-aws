variable "http_apis" {
  type = map(object({
    api_name = string
    route_key = string

    lambda_invoke_arn    = string
    lambda_function_name = string

    stage_name  = optional(string, "$default")
    auto_deploy = optional(bool, true)

    integration_timeout_ms = optional(number, 29000)

    enable_cors            = optional(bool, false)
    cors_allow_origins     = optional(list(string), ["*"])
    cors_allow_methods     = optional(list(string), ["GET","POST","PUT","DELETE","OPTIONS"])
    cors_allow_headers     = optional(list(string), ["*"])
    cors_expose_headers    = optional(list(string), [])
    cors_max_age           = optional(number, 0)
    cors_allow_credentials = optional(bool, false)

    tags        = optional(map(string), {})
    description = optional(string)
  }))
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
