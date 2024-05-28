variable "log_group_name" {}

variable "prefix" {}

variable "retention_in_days" {
  type    = number
  default = 0
}
