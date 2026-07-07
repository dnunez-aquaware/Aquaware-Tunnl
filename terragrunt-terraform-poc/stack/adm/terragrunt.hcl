include "root" {

  path = find_in_parent_folders()

}


remote_state {

  backend = "s3"

  config = {

    bucket = "bucket-state-tunnl-adm"

    key = "${path_relative_to_include()}/terraform.tfstate"

    region = "us-east-1"

    dynamodb_table = "table_lock_tunnl"

  }

}


inputs = {

  environment = "adm"

}