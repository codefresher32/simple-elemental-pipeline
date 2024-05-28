resource "aws_cloudformation_stack" "mediaconvert_job_template" {
  name = local.mediaconvert_cloudformation_stack_name
  template_body = templatefile("${path.module}/templates/cloudformation.json.tpl",
    {
      queue_arn              = aws_media_convert_queue.mediaconvert_job_queue.arn
      name                   = local.job_template_name
      settings_json          = local.settings_rendered
      status_update_interval = var.status_update_interval
      category               = var.category
      description            = var.description
    }
  )
}