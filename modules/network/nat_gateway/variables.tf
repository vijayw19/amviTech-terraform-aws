##############################################
# Input Variables for NAT Gateway
##############################################

variable "nat_gateway_name" {
  description = "Name for the NAT Gateway"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the NAT Gateway will be placed"
  type        = string
}

variable "connectivity_type" {
  description = "Connectivity type for the NAT Gateway (public or private)"
  type        = string
  default     = "public"
}

variable "allocation_id" {
  description = "Elastic IP allocation ID (if existing). Required for public NAT if not creating new EIP."
  type        = string
  default     = null
}

variable "secondary_allocation_ids" {
  description = "List of secondary EIP allocation IDs for NAT Gateway"
  type        = list(string)
  default     = []
}

variable "secondary_private_ip_address_count" {
  description = "Number of secondary private IPv4 addresses (private NAT only)"
  type        = number
  default     = 0
}

variable "secondary_private_ip_addresses" {
  description = "List of secondary private IPv4 addresses"
  type        = list(string)
  default     = []
}

variable "private_ip" {
  description = "Private IPv4 address to assign to the NAT Gateway"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be created"
  type        = string
  default     = null
}

variable "create_eip" {
  description = "Whether to create a new EIP automatically (only for public NAT)"
  type        = bool
  default     = false
}

variable "depends_on_resources" {
  description = "Explicit dependencies (e.g. Internet Gateway) to ensure proper creation order"
  type        = list(any)
  default     = []
}

variable "tags" {
  description = "Custom tags specific to this resource"
  type        = map(string)
  default     = {}
}

variable "common_tags" {
  description = "Common tags shared across resources"
  type        = map(string)
  default     = {}
}
