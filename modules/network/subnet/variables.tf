variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the subnet will be created"
  type        = string
}

variable "cidr_block" {
  description = "IPv4 CIDR block for the subnet (e.g., 10.0.1.0/24)"
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone for the subnet"
  type        = string
  default     = null
}

variable "map_public_ip_on_launch" {
  description = "Assign public IPs to instances in this subnet"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to assign to the subnet"
  type        = map(string)
  default     = {}
}

##############################################
# Optional / IPv6 and DNS Variables
##############################################

variable "availability_zone_id" {
  description = "Availability Zone ID for the subnet (optional)"
  type        = string
  default     = null
}

variable "ipv6_cidr_block" {
  description = "IPv6 CIDR block for the subnet (must use /64 prefix)"
  type        = string
  default     = null
}

variable "ipv6_native" {
  description = "Indicates whether to create an IPv6-only subnet"
  type        = bool
  default     = false
}

variable "assign_ipv6_address_on_creation" {
  description = "Automatically assign IPv6 address to interfaces in subnet"
  type        = bool
  default     = false
}

variable "enable_dns64" {
  description = "Enable synthetic IPv6 responses for IPv4-only destinations"
  type        = bool
  default     = false
}

variable "enable_resource_name_dns_a_record_on_launch" {
  description = "Respond to DNS A record queries for instance hostnames"
  type        = bool
  default     = false
}

variable "enable_resource_name_dns_aaaa_record_on_launch" {
  description = "Respond to DNS AAAA record queries for instance hostnames"
  type        = bool
  default     = false
}

variable "private_dns_hostname_type_on_launch" {
  description = "Type of private DNS hostname to assign: ip-name or resource-name"
  type        = string
  default     = null
}

variable "enable_lni_at_device_index" {
  description = "Device position for local network interfaces (e.g., eth1)"
  type        = number
  default     = null
}

