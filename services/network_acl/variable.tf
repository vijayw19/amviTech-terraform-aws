##############################################
# Variables for Service: Network ACL
##############################################

variable "environment" {
  description = "Environment name (e.g., dev, qa, prod)"
  type        = string
  default     = "dev"
}

variable "nacl_name" {
  description = "Base name for the NACL (suffix environment will be appended)"
  type        = string
  default     = "amvitech-nacl"
}

variable "vpc_id" {
  description = "VPC ID to which the NACL belongs"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with the NACL"
  type        = list(string)
  default     = []
}

variable "region" {
  description = "Region of the NACL (optional)"
  type        = string
  default     = null
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    rule_no         = number
    protocol        = string
    action          = string
    cidr_block      = optional(string)
    ipv6_cidr_block = optional(string)
    from_port       = optional(number)
    to_port         = optional(number)
    icmp_type       = optional(number)
    icmp_code       = optional(number)
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rules"
  type = list(object({
    rule_no         = number
    protocol        = string
    action          = string
    cidr_block      = optional(string)
    ipv6_cidr_block = optional(string)
    from_port       = optional(number)
    to_port         = optional(number)
    icmp_type       = optional(number)
    icmp_code       = optional(number)
  }))
  default = []
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}
