variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "name_prefix" {
  description = "Naming prefix for resources"
  type        = string
  default     = "my-dev"
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
