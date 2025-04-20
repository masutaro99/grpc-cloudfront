resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${local.resource_prefix}-ecs-cluster"
  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_iam_role_policy_attachment" "task_execution_basis" {
  role       = aws_iam_role.task_execution.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task_execution" {
  name = "${local.resource_prefix}-role-task-execution"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_security_group" "grpc_app" {
  vpc_id = module.vpc.vpc_id
  name   = "${local.resource_prefix}-sg-grpc-app"

  ingress {
    description = "HTTP from VPC"
    from_port   = 50051
    to_port     = 50051
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_cloudwatch_log_group" "grpc_app" {
  name              = "/ecs/grpc-app"
  retention_in_days = 90
}