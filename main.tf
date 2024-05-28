terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "eu-north-1-dev-video-test"
    key    = "polok/terraform/states/vod-to-live-workflow"
    region = "eu-north-1"
  }
}

variable "region" {}
variable "environment" {}
variable "mediaconvert_endpoint_url" {}

provider "aws" {
  region = var.region
}

provider "aws" {
  region = var.region
  alias  = "iam"
}

module "aws_elemental_video_pipeline" {
  source = "./terraform"

  prefix                    = "vod-to-live-workflow"
  region                    = var.region
  environment               = var.environment
  mediaconvert_endpoint_url = var.mediaconvert_endpoint_url

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

output "retriever_lambda_arn" {
  value = module.aws_elemental_video_pipeline.retriever_lambda_arn
}

output "retriever_lambda_url" {
  value = module.aws_elemental_video_pipeline.retriever_lambda_url
}

output "encoder_lambda_arn" {
  value = module.aws_elemental_video_pipeline.encoder_lambda_arn
}
