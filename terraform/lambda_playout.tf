module "playout_log_group" {
  source = "./cloudwatch"

  prefix            = var.prefix
  log_group_name    = local.playout_log_group_name
  retention_in_days = var.lambda_log_cw_retention_days
}

data "archive_file" "lambda_playout_data" {
  type        = "zip"
  source_dir  = "${path.root}/lambdas/playout"
  output_path = "${path.root}/zipped-lambdas/lambda_playout.zip"
}

resource "aws_lambda_function" "lambda_playout" {
  filename         = "${path.root}/zipped-lambdas/lambda_playout.zip"
  function_name    = local.playout_lambda_name
  role             = aws_iam_role.iam_lambda_playout.arn
  handler          = "index.handler"
  runtime          = var.lambda_runtime
  memory_size      = var.lambda_memory_size
  timeout          = var.lambda_timeout
  source_code_hash = data.archive_file.lambda_playout_data.output_path

  environment {
    variables = {
      VOD_SOURCE_BUCKET = local.vod_source_bucket_name
      SIGNEDURL_EXPIRES = var.vod_signed_urls_timeout_in_seconds
      VOD_FOLDER        = var.vod_folder
    }
  }

  tags = {
    service = var.prefix
  }
}

resource "aws_iam_role" "iam_lambda_playout" {
  provider           = aws.iam
  name               = "${var.region}-${var.environment}-${var.prefix}_playout_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "playout_cw_logs_attachment" {
  provider   = aws.iam
  role       = aws_iam_role.iam_lambda_playout.name
  policy_arn = aws_iam_policy.policy_lambda_cw_logs.arn
}
