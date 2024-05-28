
resource "aws_iam_role" "mediaconvert_role" {
  provider           = aws.iam
  name               = "${var.region}-${var.environment}-${var.prefix}_mediaconvert_role"
  assume_role_policy = data.aws_iam_policy_document.mediaconvert_assume_role_policy.json
}

data "aws_iam_policy_document" "mediaconvert_assume_role_policy" {
  provider = aws.iam
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["mediaconvert.amazonaws.com"]
    }

    effect  = "Allow"
  }
}

data "aws_iam_policy_document" "mediaconvert_s3_permissions" {
  provider = aws.iam
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListObject"
    ]

    resources = ["arn:aws:s3:::${var.vod_source_bucket_name}/*"]
  }
}
resource "aws_iam_policy" "mediaconvert_s3_policy" {
  provider = aws.iam
  name     = "${var.region}-${var.environment}-${var.prefix}_mediaconvert_s3_policy"
  policy   = data.aws_iam_policy_document.mediaconvert_s3_permissions.json
}

resource "aws_iam_role_policy_attachment" "mediaconvert_s3_policy_attachment" {
  provider   = aws.iam
  role       = aws_iam_role.mediaconvert_role.name
  policy_arn = aws_iam_policy.mediaconvert_s3_policy.arn
}