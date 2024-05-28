module "retriever_log_group" {
  source = "./cloudwatch"

  prefix            = var.prefix
  log_group_name    = local.retriever_log_group_name
  retention_in_days = var.lambda_log_cw_retention_days
}

data "archive_file" "lambda_retriever_data" {
  type        = "zip"
  source_dir  = "${path.root}/lambdas/retriever"
  output_path = "${path.root}/zipped-lambdas/lambda_retriever.zip"
}

resource "aws_lambda_function" "lambda_retriever" {
  filename         = "${path.root}/zipped-lambdas/lambda_retriever.zip"
  function_name    = local.retriever_lambda_name
  role             = aws_iam_role.iam_lambda_retriever.arn
  handler          = "index.handler"
  runtime          = var.lambda_runtime
  memory_size      = var.lambda_memory_size
  timeout          = var.lambda_timeout
  source_code_hash = data.archive_file.lambda_retriever_data.output_path

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

resource "aws_lambda_function_url" "lambda_retriever_function_url" {
  function_name      = aws_lambda_function.lambda_retriever.function_name
  authorization_type = "NONE"

  cors {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["*"]
  }
}

resource "aws_iam_role" "iam_lambda_retriever" {
  provider           = aws.iam
  name               = "${var.region}-${var.environment}-${var.prefix}_retriever_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "retriever_cw_logs_attachment" {
  provider   = aws.iam
  role       = aws_iam_role.iam_lambda_retriever.name
  policy_arn = aws_iam_policy.policy_lambda_cw_logs.arn
}

data "aws_iam_policy_document" "retriever_s3_permissions" {
  provider = aws.iam

  statement {
    actions = [
      "s3:PutObject",
      "s3:ListBucket",
    ]

    resources = [
      "${aws_s3_bucket.vod_source_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "retriever_s3_policy" {
  provider = aws.iam

  name   = "${var.region}-${var.environment}-${var.prefix}_retriever_s3_policy"
  policy = data.aws_iam_policy_document.retriever_s3_permissions.json
}

resource "aws_iam_role_policy_attachment" "retriever_s3_policy_attachment" {
  provider = aws.iam

  role       = aws_iam_role.iam_lambda_retriever.name
  policy_arn = aws_iam_policy.retriever_s3_policy.arn
}
