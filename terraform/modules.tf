module "mediapackage" {
  source         = "./mediapackage"
  prefix         = var.prefix
  vod_bucket_arn = aws_s3_bucket.vod_source_bucket.arn

  providers = {
    aws     = aws
    aws.iam = aws.iam
  }
}
