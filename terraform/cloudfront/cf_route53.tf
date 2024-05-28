resource "aws_acm_certificate" "cf_cert" {
  domain_name       = var.hostname
  validation_method = "DNS"
  provider          = aws.cloudfront

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cf_cert_validation" {
  name       = tolist(aws_acm_certificate.cf_cert.domain_validation_options)[0].resource_record_name
  type       = tolist(aws_acm_certificate.cf_cert.domain_validation_options)[0].resource_record_type
  zone_id    = var.aws_route53_zone
  records    = [tolist(aws_acm_certificate.cf_cert.domain_validation_options)[0].resource_record_value]
  ttl        = 60
  depends_on = [aws_acm_certificate.cf_cert]
}

resource "aws_acm_certificate_validation" "cf_validation" {
  certificate_arn         = aws_acm_certificate.cf_cert.arn
  validation_record_fqdns = [aws_route53_record.cf_cert_validation.fqdn]
  provider                = aws.cloudfront
}

resource "aws_route53_record" "cf_record" {
  depends_on = [aws_cloudfront_distribution.cf_distribution]
  zone_id = var.aws_route53_zone
  name    = var.hostname
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cf_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.cf_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
