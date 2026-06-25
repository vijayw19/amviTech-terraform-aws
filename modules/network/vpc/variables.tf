#########################################
# Variables for AWS VPC Module
#########################################

# ----- Basic -----
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "region" {
  description = "Region where VPC will be created (optional, defaults to provider region)"
  type        = string
  default     = null
}

variable "cidr_block" {
  description = "CIDR block for the VPC (e.g. 10.0.0.0/16)"
  type        = string
  default     = null
}

# ----- Tenancy -----
variable "instance_tenancy" {
  description = "Tenancy option: default or dedicated"
  type        = string
  default     = "default"
}

# ----- DNS -----
variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

# ----- Network Address Metrics -----
variable "enable_network_address_usage_metrics" {
  description = "Enable Network Address Usage metrics for the VPC"
  type        = bool
  default     = false
}

# ----- IPv4 IPAM -----
variable "ipv4_ipam_pool_id" {
  description = "IPv4 IPAM pool ID to allocate CIDR from"
  type        = string
  default     = null
}

variable "ipv4_netmask_length" {
  description = "Netmask length to allocate from IPv4 IPAM pool"
  type        = number
  default     = null
}

# ----- IPv6 Configuration -----
variable "assign_generated_ipv6_cidr_block" {
  description = "Whether to automatically assign an Amazon-provided IPv6 block"
  type        = bool
  default     = false
}

variable "ipv6_ipam_pool_id" {
  description = "IPv6 IPAM pool ID for allocation"
  type        = string
  default     = null
}

variable "ipv6_cidr_block" {
  description = "Explicit IPv6 CIDR block for VPC"
  type        = string
  default     = null
}

variable "ipv6_netmask_length" {
  description = "Netmask length for IPv6 from IPAM pool"
  type        = number
  default     = null
}

variable "ipv6_cidr_block_network_border_group" {
  description = "Network border group for IPv6 CIDR"
  type        = string
  default     = null
}

# ----- Tags -----
variable "tags" {
  description = "Tags to associate with the VPC"
  type        = map(string)
  default     = {}
}
