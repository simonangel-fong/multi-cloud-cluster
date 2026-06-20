# providers.tf

# ##############################
# Version
# ##############################
terraform {
  required_version = ">= v1.15.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }

  backend "s3" {}
}

# ##############################
# Providers
# ##############################
# AWS
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.tags
  }
}
