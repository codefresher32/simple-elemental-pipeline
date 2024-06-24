resource "aws_launch_template" "stream_pull_push" {
  name = "${var.region}-${var.environment}-${var.prefix}_stream_pull_push-batch"
  user_data = base64encode(templatefile("${path.module}/batch-userdata.tpl", {
    extra_user_data = var.extra_user_data,
  }))
}

resource "aws_batch_compute_environment" "stream_pull_push" {
  compute_environment_name_prefix = "${var.region}-${var.environment}-${var.prefix}_stream_pull_push-"
  type                            = "MANAGED"
  service_role                    = aws_iam_role.aws_batch_service_role.arn

  compute_resources {
    instance_role       = aws_iam_instance_profile.batch_ecs_instance_role.arn
    spot_iam_fleet_role = aws_iam_role.compute_environment_spot_fleet_role.arn

    type                = var.batch_instance_type_pricing
    instance_type       = var.batch_compute_env_instance_type
    bid_percentage      = var.batch_bid_percentage
    allocation_strategy = var.batch_instance_allocation_strategy

    min_vcpus     = var.batch_compute_env_min_vcpus
    desired_vcpus = var.batch_compute_env_desired_vcpus
    max_vcpus     = var.batch_compute_env_max_vcpus

    security_group_ids = [aws_security_group.stream_pull_push.id]
    subnets            = var.vpc_private_subnets

    launch_template {
      launch_template_id = aws_launch_template.stream_pull_push.id
      version            = aws_launch_template.stream_pull_push.latest_version
    }

    tags = {
      service = var.prefix
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.aws_batch_service_role,
    aws_iam_role.compute_environment_spot_fleet_role,
  ]

  lifecycle {
    /**
     * When changing anything in the compute env it needs to be recreated. Terraform will fail when trying to destroy
     * the compute env because the queue is dependent on it.  create_before_destroy + compute_environment_name_prefix
     * will make sure that terraform creates the new compute env before deleting the old one
     */
    create_before_destroy = true

    /**
    * There is an ongoing issue with the terraform aws provider in regards to desired vcpus. When
    * aws autoscales and this value changes, any change to the compute environment fails because
    * terraform tries to downscale desired vcpus to 0 again. We therefore ignore these changes until
    * this pr has been merged:
    * https://github.com/terraform-providers/terraform-provider-aws/pull/4855
    */
    ignore_changes = [
      compute_resources.0.desired_vcpus
    ]
  }
}

resource "aws_batch_job_queue" "stream_pull_push_default" {
  name                 = "${var.region}-${var.environment}-${var.prefix}_stream_pull_push-default"
  state                = "ENABLED"
  priority             = var.batch_job_default_queue_priority
  compute_environments = [aws_batch_compute_environment.stream_pull_push.arn]
  depends_on           = [aws_batch_compute_environment.stream_pull_push]
}

resource "aws_batch_job_definition" "stream_pull_push" {
  name = "${var.region}-${var.environment}-${var.prefix}_stream_pull_push-definition"
  type = "container"
  container_properties = templatefile("${path.module}/batch-job-definition-container-properties.json.tpl", {
    efs_mount_point     = var.batch_efs_mountpoint_container
    command             = jsonencode(var.batch_job_command)
    environment = jsonencode(
      concat(var.batch_job_environment, [
        { name = "LOCAL_DIR", value = var.batch_efs_mountpoint_container },
        { name = "ENVIRONMENT", value = var.environment },
        { name = "AWS_REGION", value = var.region },
      ])
    )
    image      = docker_registry_image.container_image.name
    memory     = var.batch_job_memory
    vcpus      = var.batch_job_vcpus
    jobRoleArn = aws_iam_role.aws_ecs_task_service_role.arn
  })
}
