##############################################
# Variables for Subnet Service Layer
##############################################

variable "aws_region" {
  description = "AWS region for subnet deployment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where subnets will be created"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}

variable "subnets" {
  description = "Map of subnet configurations"
  type = map(object({
    subnet_name       = string
    cidr_block        = string
    availability_zone = string
    map_public_ip_on_launch = optional(bool)
  }))
}
