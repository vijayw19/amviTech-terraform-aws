module "security_group" {
  source = "../../modules/network/security-group"

  sg_name     = "${var.vpc_name}-sg"
  description = "Allow SSH and HTTPS inbound, all outbound"
  vpc_id      = var.vpc_id
  region      = var.aws_region

  # Inline ingress rules (you can also use separate aws_vpc_security_group_ingress_rule resources)
  ingress_rules = [
    {
      description  = "Allow SSH from anywhere"
      from_port    = 22
      to_port      = 22
      protocol     = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    },
    {
      description  = "Allow HTTPS from VPC CIDR"
      from_port    = 443
      to_port      = 443
      protocol     = "tcp"
      cidr_blocks  = [var.vpc_cidr]
    }
  ]

  egress_rules = [
    {
      description  = "Allow all outbound"
      from_port    = 0
      to_port      = 0
      protocol     = "-1"
      cidr_blocks  = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  tags = var.common_tags
}
