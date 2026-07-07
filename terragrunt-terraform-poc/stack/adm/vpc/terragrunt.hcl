include "env" {

  path = find_in_parent_folders()

}


terraform {

  source = "../../../modules/aws-vpc"

}


inputs = {

  vpc_cidr = "10.0.0.0/16"

  public_subnet_cidr = "10.10.0.0/24"

  private_subnet_cidr = "10.20.0.0/24"

}