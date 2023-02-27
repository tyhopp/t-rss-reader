terraform {
  cloud {
    organization = "tyhopp"

    workspaces {
      name = "t-rss-reader"
    }
  }

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  access_key = var.aws-access-key
  secret_key = var.aws-secret-access-key
  region     = var.aws-region
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
data "aws_caller_identity" "current" {}
