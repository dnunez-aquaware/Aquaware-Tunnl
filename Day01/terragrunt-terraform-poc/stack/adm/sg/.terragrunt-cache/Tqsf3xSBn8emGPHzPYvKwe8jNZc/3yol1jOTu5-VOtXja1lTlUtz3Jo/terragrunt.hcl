include "root" {

  path = find_in_parent_folders("root.hcl")

}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {

  source = "../../../modules/aws-sg"

}


dependency "vpc" {

  config_path = "../vpc"

}


inputs = merge(
  local.env.inputs,
  {
    vpc_id = dependency.vpc.outputs.vpc_id
  }
)