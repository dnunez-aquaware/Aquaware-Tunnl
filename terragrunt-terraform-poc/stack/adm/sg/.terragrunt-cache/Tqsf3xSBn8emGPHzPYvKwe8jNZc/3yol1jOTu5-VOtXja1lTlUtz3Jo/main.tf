#############################
# Security Group Application
#############################

resource "aws_security_group" "ec2" {

  name = "${var.environment}-app-sg"

  description = "Security group for application workloads"

  vpc_id = var.vpc_id


  #############################
  # Ingress HTTP
  #############################

  ingress {

    description = "Allow HTTP"

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }


  #############################
  # Ingress HTTPS
  #############################

  ingress {

    description = "Allow HTTPS"

    from_port = 443

    to_port = 443

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }


  #############################
  # Egress Internet
  #############################

  egress {

    description = "Allow outbound traffic"

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }


  tags = {

    Name = "${var.environment}-app-sg"

    Environment = var.environment

    ManagedBy = "Terraform"

  }

}