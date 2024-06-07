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

resource "aws_iam_role" "iam_mediapackage_harvest_job_role" {
  provider           = aws.iam
  name               = "${var.prefix}-mediapackage-harvest-job-role"
  assume_role_policy = data.aws_iam_policy_document.mediapackage_assume_role_policy.json
}

data "aws_iam_policy_document" "harvest_job_s3_permissions" {
  provider = aws.iam

  statement {
    actions = ["s3:*"]

    resources = [
      "${var.vod_bucket_arn}",
      "${var.vod_bucket_arn}/*",
      ]
  }
}

resource "aws_iam_policy" "harvest_job_s3_policy" {
  provider = aws.iam
  name   = "${var.prefix}-mediapackage-harvest-job-s3-policy"
  policy = data.aws_iam_policy_document.harvest_job_s3_permissions.json
}

resource "aws_iam_role_policy_attachment" "harvest_job_s3_policy_attachment" {
  provider = aws.iam
  role       = aws_iam_role.iam_mediapackage_harvest_job_role.name
  policy_arn = aws_iam_policy.harvest_job_s3_policy.arn
}
