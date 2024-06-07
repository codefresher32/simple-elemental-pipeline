variable "prefix" {
  type        = string
  description = "will be applied where possible"
}

variable "vod_bucket_arn" {
  type = string
}

variable "start_over_stream_window_in_seconds" {
  type    = number
  default = 1209600
}