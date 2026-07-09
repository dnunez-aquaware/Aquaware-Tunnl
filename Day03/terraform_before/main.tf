resource "aws_s3_bucket" "bad_bucket" {
  bucket = "daniel-opa-lab-bad-bucket-demo"

  tags = {
    Name = "bad-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "bad_bucket_public_access" {
  bucket = aws_s3_bucket.bad_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_security_group" "bad_sg" {
  name        = "bad-open-sg"
  description = "Unsafe security group"

  ingress {
    description = "Open SSH to the world"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Open HTTP to the world"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bad-sg"
  }
}

resource "aws_instance" "bad_instance" {
  ami           = "ami-1234567890abcdef0"
  instance_type = "t3.2xlarge"

  tags = {
    Name = "bad-instance"
  }
}

resource "aws_iam_policy" "bad_policy" {
  name = "bad-wildcard-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })
}