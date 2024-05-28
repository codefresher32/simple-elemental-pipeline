module "encoder_log_group" {
  source = "./cloudwatch"

  prefix            = var.prefix
  log_group_name    = local.encoder_log_group_name
  retention_in_days = var.lambda_log_cw_retention_days
}

data "archive_file" "lambda_encoder_data" {
  type        = "zip"
  source_dir  = "${path.root}/lambdas/encoder"
  output_path = "${path.root}/zipped-lambdas/lambda_encoder.zip"
}

resource "aws_lambda_function" "lambda_encoder" {
  filename         = "${path.root}/zipped-lambdas/lambda_encoder.zip"
  function_name    = local.encoder_lambda_name
  role             = aws_iam_role.iam_lambda_encoder.arn
  handler          = "index.handler"
  runtime          = var.lambda_runtime
  memory_size      = var.lambda_memory_size
  timeout          = var.lambda_timeout
  source_code_hash = data.archive_file.lambda_encoder_data.output_path

  environment {
    variables = {
      VOD_SOURCE_BUCKET         = local.vod_source_bucket_name
      SIGNEDURL_EXPIRES         = var.vod_signed_urls_timeout_in_seconds
      VOD_FOLDER                = var.vod_folder
      MEDIACONVERT_ENDPOINT_URL = var.mediaconvert_endpoint_url
      MEDIACONVERT_JOB_TEMPLATE = module.mediaconvert.mediaconvert_job_template_name
      MEDIACONVERT_ROLE_ARN     = module.mediaconvert.mediaconvert_rule_arn
    }
  }

  tags = {
    service = var.prefix
  }
}

resource "aws_iam_role" "iam_lambda_encoder" {
  provider           = aws.iam
  name               = "${var.region}-${var.environment}-${var.prefix}_encoder_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "encoder_cw_logs_attachment" {
  provider   = aws.iam
  role       = aws_iam_role.iam_lambda_encoder.name
  policy_arn = aws_iam_policy.policy_lambda_cw_logs.arn
}

data "aws_iam_policy_document" "encoder_s3_permissions" {
  provider = aws.iam

  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.vod_source_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "encoder_s3_policy" {
  provider = aws.iam

  name   = "${var.region}-${var.environment}-${var.prefix}_encoder_s3_policy"
  policy = data.aws_iam_policy_document.encoder_s3_permissions.json
}

resource "aws_iam_role_policy_attachment" "encoder_s3_policy_attachment" {
  provider = aws.iam

  role       = aws_iam_role.iam_lambda_encoder.name
  policy_arn = aws_iam_policy.encoder_s3_policy.arn
}

data "aws_iam_policy_document" "encoder_mediaconvert_permissions" {
  provider = aws.iam

  statement {
    actions = [
      "mediaconvert:GetJobTemplate",
      "mediaconvert:CreateJob",
      "mediaconvert:DescribeEndpoints"
    ]

    resources = [
      "arn:aws:mediaconvert:*:*:*",
    ]
  }
}

resource "aws_iam_policy" "encoder_mediaconvert_policy" {
  provider = aws.iam
  name     = "${var.region}-${var.environment}-${var.prefix}_mediaconvert_policy"
  policy   = data.aws_iam_policy_document.encoder_mediaconvert_permissions.json
}

resource "aws_iam_role_policy_attachment" "encoder_mediaconvert_policy_attachment" {
  provider   = aws.iam
  role       = aws_iam_role.iam_lambda_encoder.name
  policy_arn = aws_iam_policy.encoder_mediaconvert_policy.arn
}

data "aws_iam_policy_document" "encoder_iam_pass_policy_document" {
  provider = aws.iam

  statement {
    actions = [
      "iam:PassRole",
    ]

    resources = [
      module.mediaconvert.mediaconvert_rule_arn
    ]
  }
}

resource "aws_iam_policy" "encoder_iam_pass_policy" {
  provider = aws.iam
  name     = "${var.region}-${var.environment}-${var.prefix}_mediaconvert_iam_pass_policy"
  policy   = data.aws_iam_policy_document.encoder_iam_pass_policy_document.json
}

resource "aws_iam_role_policy_attachment" "encoder_iam_pass_policy_attachment" {
  provider   = aws.iam
  role       = aws_iam_role.iam_lambda_encoder.name
  policy_arn = aws_iam_policy.encoder_iam_pass_policy.arn
}
