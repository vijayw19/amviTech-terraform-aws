module "internet_gateway" {
  source = "../../modules/network/igw"

  igw_name = "${var.vpc_name}-igw"
  vpc_id   = var.vpc_id
  region   = var.aws_region
  tags     = var.common_tags
}