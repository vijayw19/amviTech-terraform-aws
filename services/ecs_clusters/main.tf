module "ecs_cluster" {
  source = "../../modules/container/ecs/cluster"

  cluster_name = "${var.name_prefix}-ecs-cluster"

  settings = [
    {
      name  = "containerInsights"
      value = "enabled"
    }
  ]

  configuration = {
    execute_command_configuration = {
      logging = "DEFAULT"
      # kms_key_id = var.kms_key_arn
    }
  }

  enable_capacity_providers = true
  capacity_providers        = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy = [
    { capacity_provider = "FARGATE",      weight = 1 },
    { capacity_provider = "FARGATE_SPOT", weight = 2 }
  ]

  tags = var.common_tags
}
