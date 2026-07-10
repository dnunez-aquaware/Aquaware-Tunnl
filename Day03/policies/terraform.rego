package main

import rego.v1

# ============================================================
# Punto 4 - Initial OPA Policies
# Tagging obligatorio y restricciones generales
# ============================================================

non_taggable_resources := {
    "aws_s3_bucket_public_access_block",
    "aws_s3_bucket_server_side_encryption_configuration",
    "aws_s3_bucket_versioning",
}


deny contains msg if {
    resource := input.resource_changes[_]

    resource.change.actions[_] == "create"

    # NUEVO:
    # Ignorar recursos que no soportan tags
    not non_taggable_resources[resource.type]

    not resource.change.after.tags.Environment

    msg := sprintf(
        "Resource %s is missing required tag: Environment",
        [resource.address],
    )
}


deny contains msg if {
    resource := input.resource_changes[_]

    resource.change.actions[_] == "create"

    # NUEVO:
    # Ignorar recursos que no soportan tags
    not non_taggable_resources[resource.type]

    not resource.change.after.tags.Owner

    msg := sprintf(
        "Resource %s is missing required tag: Owner",
        [resource.address],
    )
}


deny contains msg if {
    provider_config := input.configuration.provider_config.aws

    region := provider_config.expressions.region.constant_value

    not region in {
        "us-east-1",
        "us-east-2",
        "us-west-2",
    }

    msg := sprintf(
        "AWS region %s is not allowed",
        [region],
    )
}
#-----------------------------------------------------CHALLENGE-------------------------------------------
deny contains msg if {
    resource := input.resource_changes[_]

    resource.change.actions[_] == "create"

    not non_taggable_resources[resource.type]

    not resource.change.after.tags.CostCenter

    msg := sprintf(
        "Resource %s is missing required tag: CostCenter",
        [resource.address],
    )
}

# ============================================================
# Punto 5 - S3 Production Security Policies
# Bloqueo de acceso público, cifrado y versionado
# ============================================================

deny contains msg if {
    resource := input.resource_changes[_]

    resource.type == "aws_s3_bucket_public_access_block"
    resource.change.actions[_] == "create"

    resource.change.after.block_public_acls == false

    msg := sprintf(
        "S3 bucket public ACLs must be blocked: %s",
        [resource.address],
    )
}

deny contains msg if {
    resource := input.resource_changes[_]

    resource.type == "aws_s3_bucket_public_access_block"
    resource.change.actions[_] == "create"

    resource.change.after.block_public_policy == false

    msg := sprintf(
        "S3 bucket public policies must be blocked: %s",
        [resource.address],
    )
}

deny contains msg if {
    resource := input.resource_changes[_]

    resource.type == "aws_s3_bucket_public_access_block"
    resource.change.actions[_] == "create"

    resource.change.after.ignore_public_acls == false

    msg := sprintf(
        "S3 bucket must ignore public ACLs: %s",
        [resource.address],
    )
}

deny contains msg if {
    resource := input.resource_changes[_]

    resource.type == "aws_s3_bucket_public_access_block"
    resource.change.actions[_] == "create"

    resource.change.after.restrict_public_buckets == false

    msg := sprintf(
        "S3 bucket public access must be restricted: %s",
        [resource.address],
    )
}

deny contains msg if {
    bucket := input.resource_changes[_]

    bucket.type == "aws_s3_bucket"
    bucket.change.actions[_] == "create"

    not has_s3_encryption(bucket.address)

    msg := sprintf(
        "S3 bucket must have server-side encryption configured: %s",
        [bucket.address],
    )
}

deny contains msg if {
    bucket := input.resource_changes[_]

    bucket.type == "aws_s3_bucket"
    bucket.change.actions[_] == "create"

    not has_s3_versioning(bucket.address)

    msg := sprintf(
        "S3 bucket must have versioning enabled: %s",
        [bucket.address],
    )
}

# ============================================================
# Helper functions
# Validaciones auxiliares para S3
# ============================================================

has_s3_encryption(bucket_address) if {
    bucket_name := trim_prefix(bucket_address, "aws_s3_bucket.")

    encryption := input.resource_changes[_]

    encryption.type ==
        "aws_s3_bucket_server_side_encryption_configuration"

    contains(encryption.address, bucket_name)
}


has_s3_versioning(bucket_address) if {
    bucket_name := trim_prefix(bucket_address, "aws_s3_bucket.")

    versioning := input.resource_changes[_]

    versioning.type ==
        "aws_s3_bucket_versioning"

    contains(versioning.address, bucket_name)
}
# ============================================================
# Punto 6 - Security Group Security Policies
# Bloquea exposición pública de puertos sensibles
# ============================================================

deny contains msg if {
    resource := input.resource_changes[_]

    resource.type == "aws_security_group"
    resource.change.actions[_] == "create"

    ingress := resource.change.after.ingress[_]

    ingress.cidr_blocks[_] == "0.0.0.0/0"

    ingress.from_port in {
        22,
        3389,
        5432,
        3306,
        6379,
        9200,
    }

    msg := sprintf(
        "Security group %s exposes sensitive port %v to the internet",
        [
            resource.address,
            ingress.from_port,
        ],
    )
}


# ============================================================
# Punto 7 - EC2 Instance Type Policy
# Restringe tamaños de instancia permitidos
# ============================================================

deny contains msg if {
    resource := input.resource_changes[_]

    resource.type == "aws_instance"
    resource.change.actions[_] == "create"

    instance_type := resource.change.after.instance_type

    not instance_type in {
        "t3.micro",
        "t3.small",
        "t3.medium",
    }

    msg := sprintf(
        "EC2 instance type %s is not allowed for this environment in %s",
        [
            instance_type,
            resource.address,
        ],
    )
}


# ============================================================
# Punto 8 - IAM Wildcard Policies
# Bloquea permisos excesivamente amplios
# ============================================================

deny contains msg if {
    resource := input.resource_changes[_]

    resource.type == "aws_iam_policy"
    resource.change.actions[_] == "create"

    policy := json.unmarshal(resource.change.after.policy)

    statement := policy.Statement[_]

    statement.Action == "*"
    statement.Resource == "*"

    msg := sprintf(
        "IAM policy %s allows Action '*' on Resource '*'",
        [resource.address],
    )
}


deny contains msg if {
    resource := input.resource_changes[_]

    resource.type == "aws_iam_policy"
    resource.change.actions[_] == "create"

    policy := json.unmarshal(resource.change.after.policy)

    statement := policy.Statement[_]

    action := statement.Action[_]

    action == "*"
    statement.Resource == "*"

    msg := sprintf(
        "IAM policy %s contains wildcard action and wildcard resource",
        [resource.address],
    )
}