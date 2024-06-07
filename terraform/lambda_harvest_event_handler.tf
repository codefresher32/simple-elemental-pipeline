module "harvest_event_handler_log_group" {
  source = "./cloudwatch"

  prefix            = var.prefix
  log_group_name    = local.harvest_event_handler_log_group_name
  retention_in_days = var.lambda_log_cw_retention_days
}

data "archive_file" "lambda_harvest_event_handler_data" {
  type        = "zip"
  source_dir  = "${path.root}/lambdas/mp_harvest_event_handler"
  output_path = "${path.root}/zipped-lambdas/lambda_harvest_event_handler.zip"
}

resource "aws_lambda_function" "lambda_harvest_event_handler" {
  filename         = "${path.root}/zipped-lambdas/lambda_harvest_event_handler.zip"
  function_name    = local.harvest_event_handler_lambda_name
  role             = aws_iam_role.iam_lambda_harvest_event_handler.arn
  handler          = "index.handler"
  runtime          = var.lambda_runtime
  memory_size      = var.lambda_memory_size
  timeout          = var.lambda_timeout
  source_code_hash = data.archive_file.lambda_harvest_event_handler_data.output_base64sha512

  environment {
    variables = {
      VOD_SOURCE_BUCKET = local.vod_source_bucket_name
      SIGNEDURL_EXPIRES = var.vod_signed_urls_timeout_in_seconds
      VOD_FOLDER        = var.vod_harvested_folder
    }
  }

  tags = {
    service = var.prefix
  }
}

resource "aws_iam_role" "iam_lambda_harvest_event_handler" {
  provider           = aws.iam
  name               = "${var.region}-${var.environment}-${var.prefix}_harvest_event_handler_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "harvest_event_handler_cw_logs_attachment" {
  provider   = aws.iam
  role       = aws_iam_role.iam_lambda_harvest_event_handler.name
  policy_arn = aws_iam_policy.policy_lambda_cw_logs.arn
}
