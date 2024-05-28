locals {
  mediaconvert_cloudformation_stack_name = "${var.region}-${var.environment}-${var.prefix}-mediaconvert-hls-only-default"
  job_template_name                      = "${var.region}-${var.environment}-${var.prefix}-hls-only"
  hls_audio_outputs_rendered = flatten([
    for s in var.audio_configs : [
      jsondecode(templatefile("${path.module}/templates/hls-audio-output.json.tpl", {
        audio_selector_name = s.audio_selector_name
        bitrate             = s.bitrate
        sample_rate         = s.sample_rate
        audio_track_type    = s.audio_track_type
        name_modifier       = s.name_modifier
      }))
    ]
  ])
  hls_video_outputs_rendered = flatten([
    for s in var.video_configs : [
      jsondecode(templatefile("${path.module}/templates/hls-video-output.json.tpl", {
        height          = s.height
        width           = s.width
        bitrate         = s.bitrate
        hrd_buffer_size = s.hrd_buffer_size
        name_modifier   = s.name_modifier
      }))
    ]
  ])
  hls_output_group_rendered = [jsondecode(templatefile("${path.module}/templates/hls-output-group.json.tpl", {
    outputs = jsonencode(concat(local.hls_video_outputs_rendered, local.hls_audio_outputs_rendered))
  }))]
  settings_rendered = templatefile("${path.module}/templates/jobtemplate-settings.json.tpl", {
    output_groups = jsonencode(concat(local.hls_output_group_rendered))
  })
}
