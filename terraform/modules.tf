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
