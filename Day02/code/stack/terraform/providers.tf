terraform {
  required_version = ">= 1.6"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

/*
default_tags {
    tags = {
      Owner       = "dnunez"
      CostCenter  = "bootcamp"
      Environment = "training"
      Service     = "bucket"
      Project     = "day02-tunnl"
      ManagedBy   = "terraform"
    }
  }
*/