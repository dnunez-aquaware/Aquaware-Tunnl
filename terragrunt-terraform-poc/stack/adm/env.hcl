  locals {

    environment = "adm"

    bucket = "bucket-state-tunnl-adm"

    dynamodb_table = "table_lock_tunnl"

  }

  inputs = {
  environment = local.environment
}