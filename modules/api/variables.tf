variable "api_name" { type = string }
variable "description" { type = string default = null }

variable "stage_name" {
  type    = string
  default = "$default"
}

variable "auto_deploy" {
  type    = bool
  default = true
}

##############################################
# Lambda integration inputs
##############################################
variable "lambda_invoke_arn" {
  description = "Lambda invoke ARN (module.lambda.invoke_arn)"
  type        = string
}

variable "lambda_function_name" {
  description = "Lambda function name (module.lambda.lambda_name)"
  type        = string
}

variable "route_key" {
  description = "Route key like 'GET /path' or 'ANY /{proxy+}'"
  type        = string
}

variable "integration_timeout_ms" {
  type    = number
  default = 29000
}

##############################################
# CORS toggle
##############################################
variable "enable_cors" { type = bool default = false }
variable "cors_allow_origins" { type = list(string) default = ["*"] }
variable "cors_allow_methods" { type = list(string) default = ["GET", "POST", "PUT", "DELETE", "OPTIONS"] }
variable "cors_allow_headers" { type = list(string) default = ["*"] }
variable "cors_expose_headers" { type = list(string) default = [] }
variable "cors_max_age" { type = number default = 0 }
variable "cors_allow_credentials" { type = bool default = false }

##############################################
# Tags
##############################################
variable "tags" { type = map(string) default = {} }
