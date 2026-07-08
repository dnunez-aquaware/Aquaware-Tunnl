package terraform.tags

required_tags := {
    "Owner",
    "CostCenter",
    "Environment",
    "Service",
    "Project",
    "ManagedBy"
}

deny[msg] {

    resource := input.resource_changes[_]

    resource.type == "aws_s3_bucket"

    tags := resource.change.after.tags

    required := required_tags[_]

    not tags[required]

    msg := sprintf(
        "Bucket %s is missing required tag '%s'.",
        [
            resource.name,
            required
        ]
    )
}