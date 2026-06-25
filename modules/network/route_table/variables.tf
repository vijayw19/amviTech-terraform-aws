##############################################
# Variables for AWS Route Table Module
##############################################

# ----- Basic -----
variable "route_table_name" {
  description = "Name tag for the route table"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to associate with the route table"
  type        = string
}

variable "region" {
  description = "Region where this route table will be created"
  type        = string
  default     = null
}

# ----- Route List -----
variable "routes" {
  description = <<EOT
List of route maps to create inside the route table.
Each route map supports keys:
{
  cidr_block, ipv6_cidr_block, destination_prefix_list_id,
  carrier_gateway_id, core_network_arn, egress_only_gateway_id,
  gateway_id, local_gateway_id, nat_gateway_id,
  network_interface_id, transit_gateway_id,
  vpc_endpoint_id, vpc_peering_connection_id
}
EOT
  type        = list(map(any))
  default     = []
}

# ----- Propagating VGWs -----
variable "propagating_vgws" {
  description = "List of virtual gateways for propagation"
  type        = list(string)
  default     = []
}

# ----- Tags -----
variable "tags" {
  description = "Tags to assign to the route table"
  type        = map(string)
  default     = {}
}
