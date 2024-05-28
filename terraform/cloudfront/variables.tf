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
  default = ""
}

variable "cf_name" {
  type    = string
  default = ""
}

variable "hostname" {
  type = string
}

variable "origin_hostnames" {
  type = list(string)
}

variable "ipv6_enabled" {
  type    = bool
  default = false
}

variable "response_header_policy_id" {
  type = string
}

variable "managed_cache_policy_id" {
  type = string
}

variable "default_cache_allowed_methods" {
  type    = list(string)
  default = ["HEAD", "GET", "OPTIONS"]
}

variable "default_cached_methods" {
  type    = list(string)
  default = ["GET", "HEAD"]
}

variable "viewer_protocol_policy" {
  type    = string
  default = "redirect-to-https"
}

variable "ssl_support_method" {
  type    = string
  default = "sni-only"
}

variable "minimum_protocol_version" {
  type    = string
  default = "TLSv1.2_2019"
}
