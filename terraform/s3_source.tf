resource "aws_s3_bucket" "vod_source_bucket" {
  bucket        = local.vod_source_bucket_name
  force_destroy = true

  tags = {
    service = var.prefix
  }
}

resource "aws_s3_bucket_cors_configuration" "vod_source_cors_config" {
  bucket = aws_s3_bucket.vod_source_bucket.id

  cors_rule {
    allowed_origins = ["*"]
    allowed_methods = ["GET", "HEAD"]
    max_age_seconds = 3000
    allowed_headers = ["*"]
    expose_headers  = ["ETag"]
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_notification" "vod_source_bucket_notification" {
  bucket = aws_s3_bucket.vod_source_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_encoder.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.vod_folder
  }

  depends_on = [aws_lambda_permission.vod_source_bucket_invoke_encoder_lambda]
}
