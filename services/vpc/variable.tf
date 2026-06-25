##############################################
# Variables for VPC Service Layer
# Author: Vijay | Network Stack
##############################################

variable "aws_region" {
  description = "AWS region where the VPC will be created"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC (used for tagging and identification)"
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC (e.g., 10.0.0.0/16)"
  type        = string
}

variable "enable_dns_support" {
  description = "Enable DNS support within the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames for instances within the VPC"
  type        = bool
  default     = true
}

variable "enable_network_address_usage_metrics" {
  description = "Enable network address usage metrics for the VPC"
  type        = bool
  default     = false
}

variable "instance_tenancy" {
  description = "Tenancy option for instances in the VPC (default or dedicated)"
  type        = string
  default     = "default"
}

variable "assign_generated_ipv6_cidr_block" {
  description = "Request an Amazon-provided IPv6 CIDR block (/56 prefix length)"
  type        = bool
  default     = false
}

variable "ipv4_ipam_pool_id" {
  description = "Optional IPv4 IPAM pool ID (used for automatic CIDR assignment)"
  type        = string
  default     = null
}

variable "ipv4_netmask_length" {
  description = "Optional netmask length for CIDR allocation from IPAM"
  type        = number
  default     = null
}

variable "common_tags" {
  description = "Common tags to apply to all AWS resources"
  type        = map(string)
}
