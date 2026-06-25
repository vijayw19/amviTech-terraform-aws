##############################################
# AWS Internet Gateway Module
# Author: Vijay Yadav
##############################################

resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    Name = var.igw_name
  })
}

