resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "${var.region}-${var.environment}-${var.prefix}-origin-access-identity"
}

resource "aws_cloudfront_distribution" "cf_distribution" {
  depends_on = [aws_acm_certificate_validation.cf_validation]
  aliases    = [var.hostname]

  dynamic "origin" {
    for_each = var.origin_hostnames

    content {
      domain_name = origin.value
      origin_id   = origin.value

      s3_origin_config {
        origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
      }
    }
  }

  enabled         = true
  is_ipv6_enabled = var.ipv6_enabled
  comment         = "${var.region}-${var.environment}-${var.prefix}-${var.cf_name}"

  default_cache_behavior {
    allowed_methods            = var.default_cache_allowed_methods
    cached_methods             = var.default_cached_methods
    target_origin_id           = element(var.origin_hostnames, 0)
    viewer_protocol_policy     = var.viewer_protocol_policy
    cache_policy_id            = var.managed_cache_policy_id
    compress                   = true
    response_headers_policy_id = var.response_header_policy_id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.cf_validation.certificate_arn
    ssl_support_method       = var.ssl_support_method
    minimum_protocol_version = var.minimum_protocol_version
  }
}
