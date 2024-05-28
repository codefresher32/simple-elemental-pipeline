terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "eu-north-1-dev-video-test"
    key    = "polok/terraform/states/simple-elemental"
    region = "eu-north-1"
  }
}

variable "region" {}
variable "environment" {}
variable "aws_route53_zone" {}
variable "mediaconvert_endpoint_url" {}

provider "aws" {
  region = var.region
}

provider "aws" {
  region = var.region
  alias  = "iam"
}

provider "aws" {
  region = "us-east-1"
  alias = "cloudfront"
}

module "aws_elemental_video_pipeline" {
  source = "./terraform"

  prefix                    = "simple-elemental"
  region                    = var.region
  environment               = var.environment
  aws_route53_zone          = var.aws_route53_zone
  mediaconvert_endpoint_url = var.mediaconvert_endpoint_url

  providers = {
    aws     = aws
    aws.iam = aws.iam
    aws.cloudfront = aws.cloudfront
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

output "mediaconvert_cf_domain" {
  value = module.aws_elemental_video_pipeline.mediaconvert_cf_domain
}
