locals {
  create_harvest_job_lambda_name       = "${var.region}-${var.environment}-${var.prefix}_create_harvest_job"
  create_harvest_job_log_group_name    = "/aws/lambda/${local.create_harvest_job_lambda_name}"
  harvest_event_handler_lambda_name    = "${var.region}-${var.environment}-${var.prefix}_harvest_event_handler"
  harvest_event_handler_log_group_name = "/aws/lambda/${local.harvest_event_handler_lambda_name}"
  vod_source_bucket_name               = "${var.region}-${var.environment}-${var.prefix}-vod-source"
}
