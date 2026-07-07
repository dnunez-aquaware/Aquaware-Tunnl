include "root" {

  path = find_in_parent_folders("root.hcl")

}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {

  source = "../../../modules/aws-vpc"

}


inputs = merge(
  local.env.inputs,
  {
    vpc_cidr = "10.100.0.0/16"

    public_subnets = [
      "10.100.1.0/24",
      "10.100.2.0/24"
    ]

    private_subnets = [
      "10.100.10.0/24",
      "10.100.20.0/24"
    ]
  }
)