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
