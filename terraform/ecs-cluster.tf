resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${local.resource_prefix}-ecs-cluster"
  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}