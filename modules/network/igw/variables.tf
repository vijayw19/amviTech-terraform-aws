##############################################
# Variables for AWS Internet Gateway Module
##############################################

# ----- Basic -----
variable "igw_name" {
  description = "Name tag for the Internet Gateway"
  type        = string
}

variable "region" {
  description = "Region where this Internet Gateway will be created"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC ID to attach the Internet Gateway to"
  type        = string
  default     = null
}

# ----- Tags -----
variable "tags" {
  description = "Tags to assign to the Internet Gateway"
  type        = map(string)
  default     = {}
}
