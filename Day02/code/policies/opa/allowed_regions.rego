package terraform.region

allowed_regions := {
    "us-east-1"
}

deny[msg] {

    config := input.configuration.provider_config.aws.expressions.region.constant_value

    not allowed_regions[config]

    msg := sprintf(
        "Region '%s' is not allowed.",
        [config]
    )
}