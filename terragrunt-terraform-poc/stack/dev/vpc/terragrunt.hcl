include "env" {

  path = find_in_parent_folders()

}


terraform {

  source = "../../../modules/aws-vpc"

}


inputs = {

  vpc_cidr = "10.100.0.0/16"

  public_subnet_cidr = "10.110.0.0/24"

  private_subnet_cidr = "10.120.0.0/24"

}