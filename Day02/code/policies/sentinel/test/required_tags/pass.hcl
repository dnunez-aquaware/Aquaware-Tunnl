mock "tfplan/v2" {
  data = {
    resource_changes = [
      {
        address = "aws_s3_bucket.demo"

        type = "aws_s3_bucket"

        change = {
          after = {
            tags_all = {
              CostCenter  = "bootcamp"
              Environment = "training"
              ManagedBy   = "terraform"
              Owner       = "dnunez"
              Project     = "day02-tunnl"
              Service     = "bucket"
            }
          }
        }
      }
    ]
  }
}