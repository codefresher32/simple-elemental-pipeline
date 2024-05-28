resource "aws_media_convert_queue" "mediaconvert_job_queue" {
  name = "${var.region}-${var.environment}-${var.prefix}-mediaconvert-hls-job-queue"

  tags = {
    service = var.prefix
  }
}
