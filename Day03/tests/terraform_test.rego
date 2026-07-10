package main

import rego.v1


# ============================================================
# Punto 10 - OPA Unit Tests
# Validación automática de políticas de seguridad
# ============================================================


# ============================================================
# Test - Missing Environment Tag
#
# Debe fallar porque el bucket no tiene Environment
# ============================================================

test_deny_missing_environment_tag if {
    test_input := {
        "resource_changes": [
            {
                "address": "aws_s3_bucket.example",
                "type": "aws_s3_bucket",
                "change": {
                    "actions": ["create"],
                    "after": {
                        "tags": {
                            "Owner": "platform-team",
                        },
                    },
                },
            },
        ],
        "configuration": {
            "provider_config": {
                "aws": {
                    "expressions": {
                        "region": {
                            "constant_value": "us-east-1",
                        },
                    },
                },
            },
        },
    }

    result := deny with input as test_input

    count(result) > 0
}


# ============================================================
# Test - Open SSH Security Group
#
# Debe fallar porque expone SSH (22)
# a Internet (0.0.0.0/0)
# ============================================================

test_deny_open_ssh if {
    test_input := {
        "resource_changes": [
            {
                "address": "aws_security_group.bad",
                "type": "aws_security_group",
                "change": {
                    "actions": ["create"],
                    "after": {
                        "tags": {
                            "Environment": "dev",
                            "Owner": "platform-team",
                        },
                        "ingress": [
                            {
                                "from_port": 22,
                                "to_port": 22,
                                "cidr_blocks": [
                                    "0.0.0.0/0",
                                ],
                            },
                        ],
                    },
                },
            },
        ],
        "configuration": {
            "provider_config": {
                "aws": {
                    "expressions": {
                        "region": {
                            "constant_value": "us-east-1",
                        },
                    },
                },
            },
        },
    }

    result := deny with input as test_input

    count(result) > 0
}