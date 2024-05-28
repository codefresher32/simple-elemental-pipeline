module "mediaconvert" {
  source = "./mediaconvert"

  prefix                 = var.prefix
  region                 = var.region
  environment            = var.environment
  vod_source_bucket_name = local.vod_source_bucket_name

  providers = {
    aws     = aws
    aws.iam = aws.iam
  }
}

module "cloudfront_s3" {
  source = "./cloudfront"

  prefix                    = var.prefix
  region                    = var.region
  environment               = var.environment
  cf_name                   = local.cf_mediaconvert
  aws_route53_zone          = var.aws_route53_zone
  hostname                  = local.mediaconvert_s3_hostname
  origin_hostnames          = [aws_s3_bucket.vod_source_bucket.bucket_regional_domain_name]
  response_header_policy_id = resource.aws_cloudfront_response_headers_policy.cors_with_preflight_response_header_policy.id
  managed_cache_policy_id   = data.aws_cloudfront_cache_policy.managed_caching_optimized_cache_policy.id

  providers = {
    aws            = aws
    aws.cloudfront = aws.cloudfront
  }
}
