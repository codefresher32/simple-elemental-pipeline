output "vod_source_bucket_name" {
  value = aws_s3_bucket.vod_source_bucket.id
}

output "vod_source_bucket_arn" {
  value = aws_s3_bucket.vod_source_bucket.arn
}

output "harvest_event_handler_lambda_arn" {
  value = aws_lambda_function.lambda_harvest_event_handler.arn
}

output "create_harvest_job_lambda_arn" {
  value = aws_lambda_function.lambda_create_harvest_job.arn
}

output "create_harvest_job_lambda_url" {
  value = aws_lambda_function_url.lambda_create_harvest_job_function_url.function_url
}
