resource "aws_lb" "alb" {
  name                       = "${local.resource_prefix}-alb"
  load_balancer_type         = "application"
  internal                   = "false"
  idle_timeout               = 60
  enable_deletion_protection = false

  subnets = module.vpc.public_subnets

  security_groups = [
    aws_security_group.alb.id
  ]
}

resource "aws_security_group" "alb" {
  vpc_id = module.vpc.vpc_id
  name   = "${local.resource_prefix}-sg-alb"

  ingress {
    description = "HTTP from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_lb_listener" "grpc" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = module.alb_acm.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grpc_app.arn
  }
}

resource "aws_lb_target_group" "grpc_app" {
  name                 = "${local.resource_prefix}-tg-grpc-app"
  target_type          = "ip"
  port                 = 50051
  protocol             = "HTTP"
  protocol_version     = "GRPC"
  vpc_id               = module.vpc.vpc_id
}
