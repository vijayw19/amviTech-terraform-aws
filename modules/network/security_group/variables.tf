##############################################
# Variables for AWS Security Group Module
##############################################

# ----- Basic -----
variable "sg_name" {
  description = "Name of the security group"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Prefix used to generate a unique SG name (conflicts with sg_name)"
  type        = string
  default     = null
}

variable "description" {
  description = "Security group description"
  type        = string
  default     = "Managed by Terraform"
}

variable "region" {
  description = "Region where the security group will be created"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC ID for the security group"
  type        = string
  default     = null
}

# ----- Ingress & Egress Rules -----
# Although AWS recommends separate resources, this allows optional inline definition.
variable "ingress_rules" {
  description = <<EOT
List of ingress rule maps.
Each object supports:
{
  from_port, to_port, protocol, cidr_blocks, ipv6_cidr_blocks,
  prefix_list_ids, description, security_groups
}
EOT
  type        = list(map(any))
  default     = []
}

variable "egress_rules" {
  description = <<EOT
List of egress rule maps.
Each object supports:
{
  from_port, to_port, protocol, cidr_blocks, ipv6_cidr_blocks,
  prefix_list_ids, description, security_groups
}
EOT
  type        = list(map(any))
  default     = []
}

# ----- Lifecycle & Deletion Controls -----
variable "revoke_rules_on_delete" {
  description = "Revoke all attached rules before deletion (for EMR or cyclic dependencies)"
  type        = bool
  default     = false
}

variable "create_before_destroy" {
  description = "Create new SG before destroying old one (avoids dependency issues)"
  type        = bool
  default     = true
}

# ----- Timeouts -----
variable "timeout_create" {
  description = "Timeout for SG creation"
  type        = string
  default     = "10m"
}

variable "timeout_delete" {
  description = "Timeout for SG deletion (45m for Lambda VPC networking issue)"
  type        = string
  default     = "45m"
}

# ----- Tags -----
variable "tags" {
  description = "Tags to assign to the security group"
  type        = map(string)
  default     = {}
}
