resource "aws_cloudfront_distribution" "grpc_app" {
  aliases         = ["${local.cloudfront_sub_domain_name}.${local.hosted_zone_name}"]
  enabled         = true
  http_version    = "http2"
  is_ipv6_enabled = true
  price_class     = "PriceClass_All"
  default_cache_behavior {
    allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" // Managed-CachingDisabled
    cached_methods           = ["GET", "HEAD"]
    compress                 = true
    default_ttl              = 0
    max_ttl                  = 0
    min_ttl                  = 0
    origin_request_policy_id = "b689b0a8-53d0-40ab-baf2-68738e2966ac" // Managed-AllViewerExceptHostHeader
    target_origin_id         = "${local.alb_sub_domain_name}.${local.hosted_zone_name}"
    viewer_protocol_policy   = "https-only"
    grpc_config {
      enabled = true
    }
  }
  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = "${local.alb_sub_domain_name}.${local.hosted_zone_name}"
    origin_id           = "${local.alb_sub_domain_name}.${local.hosted_zone_name}"
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["JP"]
    }
  }
  viewer_certificate {
    acm_certificate_arn            = module.cloudfront_acm.acm_certificate_arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}
