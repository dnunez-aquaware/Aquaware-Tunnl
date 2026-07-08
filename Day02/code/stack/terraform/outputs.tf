output "bucket_name" {
  description = "Name of the S3 bucket"

  value = aws_s3_bucket.demo.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"

  value = aws_s3_bucket.demo.arn
}

output "bucket_id" {
  description = "ID of the S3 bucket"

  value = aws_s3_bucket.demo.id
}

output "bucket_domain_name" {
  description = "Bucket regional domain name"

  value = aws_s3_bucket.demo.bucket_regional_domain_name
}