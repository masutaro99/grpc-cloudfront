data "aws_route53_zone" "hostzone" {
  name = local.hosted_zone_name
}

module "alb_acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 5.1.1"

  domain_name = "${local.alb_sub_domain_name}.${local.hosted_zone_name}"
  zone_id     = data.aws_route53_zone.hostzone.zone_id

  validation_method   = "DNS"
  wait_for_validation = true

  tags = {
    Name = "${local.alb_sub_domain_name}.${local.hosted_zone_name}"
  }
}

module "cloudfront_acm" {
  providers = {
    aws = aws.us-east-1
  }

  source  = "terraform-aws-modules/acm/aws"
  version = "~> 5.1.1"

  domain_name = "${local.cloudfront_sub_domain_name}.${local.hosted_zone_name}"
  zone_id     = data.aws_route53_zone.hostzone.zone_id

  validation_method   = "DNS"
  wait_for_validation = true

  tags = {
    Name = "${local.cloudfront_sub_domain_name}.${local.hosted_zone_name}"
  }
}