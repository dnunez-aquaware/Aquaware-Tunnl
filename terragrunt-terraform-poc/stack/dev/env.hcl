locals {
  environment    = "dev"
  bucket         = "bucket-state-tunnl-dev"
  dynamodb_table = "table_lock_tunnl"
}

remote_state {

  backend = "s3"

  config = {
    bucket         = local.bucket
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = local.dynamodb_table
  }

}

inputs = {
  environment = local.environment
}