data "aws_iam_policy_document" "mediapackage_assume_role_policy" {
  provider = aws.iam
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["mediapackage.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "iam_mediapackage_harvest_role" {
  provider           = aws.iam
  name               = "${var.region}-${var.environment}-${var.prefix}_mediapackage_harvest_role"
  assume_role_policy = data.aws_iam_policy_document.mediapackage_assume_role_policy.json
}

data "aws_iam_policy_document" "harvest_job_s3_permissions" {
  provider = aws.iam

  statement {
    actions = ["s3:*"]

    resources = [
      "${aws_s3_bucket.vod_source_bucket.arn}",
      "${aws_s3_bucket.vod_source_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "harvest_job_s3_policy" {
  provider = aws.iam

  name   = "${var.region}-${var.environment}-${var.prefix}_harvest_job_s3_policy"
  policy = data.aws_iam_policy_document.harvest_job_s3_permissions.json
}

resource "aws_iam_role_policy_attachment" "harvest_job_s3_policy_attachment" {
  provider = aws.iam

  role       = aws_iam_role.iam_mediapackage_harvest_role.name
  policy_arn = aws_iam_policy.harvest_job_s3_policy.arn
}
