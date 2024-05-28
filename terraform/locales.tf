locals {
  retriever_lambda_name    = "${var.region}-${var.environment}-${var.prefix}_retriever"
  retriever_log_group_name = "/aws/lambda/${local.retriever_lambda_name}"
  encoder_lambda_name      = "${var.region}-${var.environment}-${var.prefix}_encoder"
  encoder_log_group_name   = "/aws/lambda/${local.encoder_lambda_name}"
  vod_source_bucket_name   = "${var.region}-${var.environment}-${var.prefix}-vod-source"
}
