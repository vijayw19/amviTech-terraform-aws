##############################################
# Core
##############################################
variable "function_name" { type = string }
variable "description"   { type = string default = null }

variable "runtime" { type = string }
variable "handler" { type = string }

variable "role_arn" {
  description = "Existing IAM role ARN for Lambda execution"
  type        = string
}

##############################################
# Packaging toggles
##############################################
variable "use_local_zip" {
  description = "Use local zip file packaging"
  type        = bool
  default     = false
}

variable "filename" {
  description = "Local zip path (required if use_local_zip=true)"
  type        = string
  default     = null
}

variable "source_code_hash" {
  description = "base64sha256(file) for local zip (recommended)"
  type        = string
  default     = null
}

variable "use_s3_package" {
  description = "Use S3 object as Lambda package (recommended for CI/CD)"
  type        = bool
  default     = true
}

variable "s3_bucket" { type = string default = null }
variable "s3_key"    { type = string default = null }
variable "s3_object_version" { type = string default = null }

##############################################
# Runtime settings
##############################################
variable "memory_size" { type = number default = 256 }
variable "timeout"     { type = number default = 30 }
variable "architectures" {
  description = "x86_64 or arm64"
  type        = list(string)
  default     = ["x86_64"]
}
variable "publish" { type = bool default = false }

##############################################
# Concurrency toggle
##############################################
variable "enable_reserved_concurrency" { type = bool default = false }
variable "reserved_concurrent_executions" { type = number default = null }

##############################################
# Ephemeral storage
##############################################
variable "ephemeral_storage_size" {
  description = "512-10240 (MB)"
  type        = number
  default     = 512
}

##############################################
# Env vars
##############################################
variable "environment_variables" {
  type    = map(string)
  default = {}
}

##############################################
# VPC toggle
##############################################
variable "enable_vpc_config" { type = bool default = false }
variable "subnet_ids"        { type = list(string) default = [] }
variable "security_group_ids" { type = list(string) default = [] }

##############################################
# X-Ray toggle
##############################################
variable "enable_xray" { type = bool default = false }

##############################################
# Dead letter toggle
##############################################
variable "enable_dead_letter" { type = bool default = false }
variable "dead_letter_target_arn" { type = string default = null }

##############################################
# Log group toggle
##############################################
variable "create_log_group" { type = bool default = true }
variable "log_retention_in_days" { type = number default = 14 }
variable "log_kms_key_id" { type = string default = null }

##############################################
# Function URL toggle
##############################################
variable "enable_function_url" { type = bool default = false }
variable "function_url_auth_type" {
  description = "NONE or AWS_IAM"
  type        = string
  default     = "NONE"
}

variable "enable_function_url_cors" { type = bool default = false }
variable "function_url_cors_allow_origins" { type = list(string) default = ["*"] }
variable "function_url_cors_allow_methods" { type = list(string) default = ["*"] }
variable "function_url_cors_allow_headers" { type = list(string) default = ["*"] }
variable "function_url_cors_expose_headers" { type = list(string) default = [] }
variable "function_url_cors_max_age" { type = number default = 0 }
variable "function_url_cors_allow_credentials" { type = bool default = false }

##############################################
# Tags
##############################################
variable "tags" { type = map(string) default = {} }
