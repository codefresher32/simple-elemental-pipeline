terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "region" {
  type = string
  default = "eu-north-1"
}

variable "environment" {
  type = string
  default = "dev"
}

provider "aws" {
  region = var.region
}

provider "aws" {
  region = var.region
  alias  = "iam"
}

module "aws_elemental_video_pipeline" {
  source = "./terraform"

  prefix                    = "live-to-vod-workflow"
  region                    = var.region
  environment               = var.environment

  providers = {
    aws     = aws
    aws.iam = aws.iam
  }
}

output "vod_source_bucket_name" {
  value = module.aws_elemental_video_pipeline.vod_source_bucket_name
}

output "vod_source_bucket_arn" {
  value = module.aws_elemental_video_pipeline.vod_source_bucket_arn
}

output "harvest_event_handler_lambda_arn" {
  value = module.aws_elemental_video_pipeline.harvest_event_handler_lambda_arn
}

output "create_harvest_job_lambda_arn" {
  value = module.aws_elemental_video_pipeline.create_harvest_job_lambda_arn
}

output "create_harvest_job_lambda_url" {
  value = module.aws_elemental_video_pipeline.create_harvest_job_lambda_url
}
