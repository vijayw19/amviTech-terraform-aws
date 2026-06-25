##############################################
# Variables for Internet Gateway Service Layer
##############################################

variable "aws_region" {
  description = "AWS region where the Internet Gateway will be deployed"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to attach the Internet Gateway to"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC (used for naming the IGW)"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}
