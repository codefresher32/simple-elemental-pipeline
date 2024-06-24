data "aws_iam_policy_document" "ecs_assume_role_ec2" {
  provider = aws.iam
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

variable "batch_ecs_instance_role_suffix" {
  default = "pull-push-ecs-instance"
}

resource "aws_iam_role" "batch_ecs_instance" {
  provider             = aws.iam
  name                 = "${var.region}-${var.environment}-${var.prefix}_${var.batch_ecs_instance_role_suffix}"
  assume_role_policy   = data.aws_iam_policy_document.ecs_assume_role_ec2.json
  permissions_boundary = var.iam_role_permission_boundary_arn
}

resource "aws_iam_role_policy_attachment" "batch_ecs_instance_role" {
  provider   = aws.iam
  role       = aws_iam_role.batch_ecs_instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "batch_ecs_instance_role" {
  provider = aws.iam
  name     = "${var.region}-${var.environment}-${var.prefix}_batch-stream-pull-push-ecs"
  role     = aws_iam_role.batch_ecs_instance.name
}

data "aws_iam_policy_document" "assume_role_batch" {
  provider = aws.iam
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["batch.amazonaws.com"]
      type        = "Service"
    }
  }
}

variable "aws_batch_service_role_suffix" {
  default = "pull-push-batch-role"
}

resource "aws_iam_role" "aws_batch_service_role" {
  provider             = aws.iam
  name                 = "${var.region}-${var.environment}-${var.prefix}_${var.aws_batch_service_role_suffix}"
  assume_role_policy   = data.aws_iam_policy_document.assume_role_batch.json
  permissions_boundary = var.iam_role_permission_boundary_arn
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role" {
  provider   = aws.iam
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

data "aws_iam_policy_document" "assume_role_batch_ecs_task" {
  provider = aws.iam
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

variable "aws_ecs_task_service_role_suffix" {
  default = "pull-push-ecs-role"
}
resource "aws_iam_role" "aws_ecs_task_service_role" {
  provider             = aws.iam
  name                 = "${var.region}-${var.environment}-${var.prefix}_${var.aws_ecs_task_service_role_suffix}"
  assume_role_policy   = data.aws_iam_policy_document.assume_role_batch_ecs_task.json
  permissions_boundary = var.iam_role_permission_boundary_arn
}

variable "spot_fleet_policy_suffix" {
  default = "spot-fleet-pull-push"
}

data "aws_iam_policy_document" "spot_fleet_assume_role_policy" {
  provider = aws.iam
  statement {
    sid    = "1"
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      identifiers = [
        "spotfleet.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "compute_environment_spot_fleet_role" {
  provider             = aws.iam
  name                 = "${var.region}-${var.environment}-${var.prefix}-${var.spot_fleet_policy_suffix}"
  permissions_boundary = var.iam_role_permission_boundary_arn
  assume_role_policy   = data.aws_iam_policy_document.spot_fleet_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "compute_environment_spot_fleet_tagging_policy_attachment" {
  provider   = aws.iam
  role       = aws_iam_role.compute_environment_spot_fleet_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2SpotFleetTaggingRole"
}

data "aws_iam_policy_document" "mediapackage_channel_permissions" {
  provider = aws.iam
  statement {
    sid = "1"

    actions = ["mediapackage:*"]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "mediapackage_channel_policy" {
  provider = aws.iam
  name     = "${var.region}-${var.environment}-${var.prefix}_stream_pull_push_mediapackage_channel_permissions"
  policy   = data.aws_iam_policy_document.mediapackage_channel_permissions.json
}

resource "aws_iam_role_policy_attachment" "mediapackage_channel_permissions_attachment" {
  provider   = aws.iam
  role       = aws_iam_role.aws_ecs_task_service_role.name
  policy_arn = aws_iam_policy.mediapackage_channel_policy.arn
}
