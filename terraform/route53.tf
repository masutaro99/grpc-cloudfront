resource "aws_route53_record" "alb" {
  zone_id = data.aws_route53_zone.hostzone.zone_id
  name    = "${local.alb_sub_domain_name}.${local.hosted_zone_name}"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cloudfront" {
  zone_id = data.aws_route53_zone.hostzone.zone_id
  name    = "${local.cloudfront_sub_domain_name}.${local.hosted_zone_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.grpc_app.domain_name
    zone_id                = aws_cloudfront_distribution.grpc_app.hosted_zone_id
    evaluate_target_health = false
  }
}