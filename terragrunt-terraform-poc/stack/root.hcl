locals {

  env = read_terragrunt_config(
    find_in_parent_folders("env.hcl")
  )

}


remote_state {

  backend = "s3"

  config = {

    bucket = local.env.locals.bucket

    key = "${path_relative_to_include()}/terraform.tfstate"

    region = "us-east-1"

    dynamodb_table = local.env.locals.dynamodb_table

  }

}


generate "provider" {

  path = "provider.tf"

  if_exists = "overwrite"

  contents = <<EOF

provider "aws" {

  region = "us-east-1"

}

EOF

}