package main

required_tags := {
    "Owner",
    "CostCenter",
    "Environment",
    "Service",
    "Project",
    "ManagedBy"
}

deny contains msg if {

    resource := input.resource_changes[_]

    resource.type == "aws_s3_bucket"

    tags := object.get(resource.change.after, "tags", {})

    required := required_tags[_]

    not object.get(tags, required, null)

    msg := sprintf(
        "Bucket %s is missing required tag '%s'.",
        [
            resource.name,
            required
        ]
    )
}