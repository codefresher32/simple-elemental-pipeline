module "create_harvest_job_log_group" {
  source = "./cloudwatch"

  prefix            = var.prefix
  log_group_name    = local.create_harvest_job_log_group_name
  retention_in_days = var.lambda_log_cw_retention_days
}

data "archive_file" "lambda_create_harvest_job_data" {
  type        = "zip"
  source_dir  = "${path.root}/lambdas/create_harvest_job"
  output_path = "${path.root}/zipped-lambdas/lambda_create_harvest_job.zip"
}

resource "aws_lambda_function" "lambda_create_harvest_job" {
  filename         = "${path.root}/zipped-lambdas/lambda_create_harvest_job.zip"
  function_name    = local.create_harvest_job_lambda_name
  role             = aws_iam_role.iam_lambda_create_harvest_job.arn
  handler          = "index.handler"
  runtime          = var.lambda_runtime
  memory_size      = var.lambda_memory_size
  timeout          = var.lambda_timeout
  source_code_hash = data.archive_file.lambda_create_harvest_job_data.output_base64sha512

  environment {
    variables = {
      MP_HARVEST_ROLE_ARN  = aws_iam_role.iam_mediapackage_harvest_role.arn
      VOD_SOURCE_BUCKET    = local.vod_source_bucket_name
      VOD_HARVESTED_FOLDER = var.vod_harvested_folder
    }
  }

  tags = {
    service = var.prefix
  }
}

resource "aws_lambda_function_url" "lambda_create_harvest_job_function_url" {
  function_name      = aws_lambda_function.lambda_create_harvest_job.function_name
  authorization_type = "NONE"

  cors {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["*"]
  }
}

resource "aws_iam_role" "iam_lambda_create_harvest_job" {
  provider           = aws.iam
  name               = "${var.region}-${var.environment}-${var.prefix}_create_harvest_job_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "create_harvest_job_cw_logs_attachment" {
  provider   = aws.iam
  role       = aws_iam_role.iam_lambda_create_harvest_job.name
  policy_arn = aws_iam_policy.policy_lambda_cw_logs.arn
}

data "aws_iam_policy_document" "create_harvest_job_mp_permissions" {
  provider = aws.iam

  statement {
    actions = ["mediapackage:*"]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "create_harvest_job_mp_policy" {
  provider = aws.iam

  name   = "${var.region}-${var.environment}-${var.prefix}_create_harvest_job_mp_policy"
  policy = data.aws_iam_policy_document.create_harvest_job_mp_permissions.json
}

resource "aws_iam_role_policy_attachment" "create_harvest_job_mp_policy_attachment" {
  provider = aws.iam

  role       = aws_iam_role.iam_lambda_create_harvest_job.name
  policy_arn = aws_iam_policy.create_harvest_job_mp_policy.arn
}

data "aws_iam_policy_document" "mp_harvest_role_pass_to_create_harvest_job_lambda" {
  provider = aws.iam
  statement {
    actions = [
      "iam:PassRole",
    ]
    resources = [aws_iam_role.iam_mediapackage_harvest_role.arn]
  }
}

resource "aws_iam_policy" "mp_harvest_role_pass_policy" {
  provider = aws.iam

  name   = "${var.region}-${var.environment}-${var.prefix}_mp_harvest_role_pass_to_create_harvest_lambda_policy"
  policy = data.aws_iam_policy_document.mp_harvest_role_pass_to_create_harvest_job_lambda.json
}

resource "aws_iam_role_policy_attachment" "mp_harvest_role_pass_policy_attachment" {
  provider = aws.iam

  role       = aws_iam_role.iam_lambda_create_harvest_job.name
  policy_arn = aws_iam_policy.mp_harvest_role_pass_policy.arn
}
