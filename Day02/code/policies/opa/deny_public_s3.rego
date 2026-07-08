package terraform.s3

deny[msg] {
    resource := input.resource_changes[_]

    resource.type == "aws_s3_bucket_public_access_block"

    resource.change.after.block_public_acls != true

    msg := "S3 buckets must block public ACLs."
}

deny[msg] {
    resource := input.resource_changes[_]

    resource.type == "aws_s3_bucket_public_access_block"

    resource.change.after.block_public_policy != true

    msg := "S3 buckets must block public bucket policies."
}