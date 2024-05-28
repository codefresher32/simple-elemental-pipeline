output "mediaconvert_job_template_name" {
  value = aws_cloudformation_stack.mediaconvert_job_template.outputs["JobTemplateName"]
}

output "mediaconvert_rule_arn" {
  value = aws_iam_role.mediaconvert_role.arn
}

output "mediaconvert_queue_arn" {
  value = aws_media_convert_queue.mediaconvert_job_queue.arn
}
