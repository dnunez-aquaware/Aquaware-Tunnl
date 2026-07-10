terraform {
  backend "s3" {
    #se podria poner las propiedades aqui directamente de backend.hcl

  }
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.7"
    }
  }
}

provider "aws" {

  region = "us-east-1"

  default_tags {
    tags = {
      Owner       = "dnunez"
      CostCenter  = "bootcamp"
      Environment = "training"
      Service     = "bucket"
      Project     = "Day04-tofu"
      ManagedBy   = "terraform"
    }
  }
}