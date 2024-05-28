output "vod_source_bucket_name" {
  value = aws_s3_bucket.vod_source_bucket.id
}

output "vod_source_bucket_arn" {
  value = aws_s3_bucket.vod_source_bucket.arn
}

output "retriever_lambda_arn" {
  value = aws_lambda_function.lambda_retriever.arn
}

output "retriever_lambda_url" {
  value = aws_lambda_function_url.lambda_retriever_function_url.function_url
}

output "encoder_lambda_arn" {
  value = aws_lambda_function.lambda_encoder.arn
}

output "playout_lambda_arn" {
  value = aws_lambda_function.lambda_playout.arn
}

output "mediaconvert_cf_domain" {
  value = module.cloudfront_s3.cf_domain
}

output "origin_access_identity_iam_arn" {
  value = module.cloudfront_s3.origin_access_identity_iam_arn
}
