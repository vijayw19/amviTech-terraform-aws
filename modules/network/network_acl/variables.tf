##############################################
# Input Variables for Network ACL
##############################################

variable "nacl_name" {
  description = "Name of the Network ACL"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the Network ACL will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of Subnet IDs to associate with the Network ACL"
  type        = list(string)
  default     = []
}

variable "region" {
  description = "Region for the Network ACL (optional)"
  type        = string
  default     = null
}

variable "ingress_rules" {
  description = "List of ingress rules for the NACL"
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
  description = "List of egress rules for the NACL"
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

variable "tags" {
  description = "Custom tags for this NACL resource"
  type        = map(string)
  default     = {}
}

variable "common_tags" {
  description = "Common tags to be applied across resources"
  type        = map(string)
  default     = {}
}
