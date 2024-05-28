variable "prefix" {
  type        = string
  description = "AWS Resources name prefix"
}

variable "region" {
  type    = string
  default = ""
}

variable "environment" {
  type    = string
  default = ""
}

variable "aws_route53_zone" {
  type = string
}

variable "mediaconvert_endpoint_url" {
  type    = string
  default = ""
}

variable "vod_folder" {
  type    = string
  default = "retrieved/"
}

variable "lambda_log_cw_retention_days" {
  type    = number
  default = 30
}

variable "lambda_runtime" {
  default = "nodejs20.x"
}

variable "lambda_memory_size" {
  default = 256
}

variable "lambda_timeout" {
  default = 30
}

variable "vod_signed_urls_timeout_in_seconds" {
  default = 3600
}
