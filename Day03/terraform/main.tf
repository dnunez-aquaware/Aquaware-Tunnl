resource "aws_s3_bucket" "good_bucket" {
  bucket = "daniel-opa-lab-good-bucket-demo"

  tags = {
    Name        = "good-bucket"
    Environment = var.environment
    Owner       = "platform-team"
    CostCenter  = "challengeA"
  }
}

resource "aws_s3_bucket_public_access_block" "good_bucket_public_access" {
  bucket = aws_s3_bucket.good_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "good_bucket_encryption" {
  bucket = aws_s3_bucket.good_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "good_bucket_versioning" {
  bucket = aws_s3_bucket.good_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_security_group" "good_sg" {
  name        = "good-private-sg"
  description = "Safe security group"

  ingress {
    description = "Internal HTTP only"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "good-sg"
    Environment = var.environment
    Owner       = "platform-team"
    CostCenter  = "challengeA"
  }
}

resource "aws_instance" "good_instance" {
  ami           = "ami-1234567890abcdef0"
  instance_type = "t3.micro"

  tags = {
    Name        = "good-instance"
    Environment = var.environment
    Owner       = "platform-team"
    CostCenter  = "challengeA"
  }
}

resource "aws_iam_policy" "good_policy" {
  name = "good-readonly-s3-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:ListBucket",
        ]

        Resource = [
          aws_s3_bucket.good_bucket.arn,
          "${aws_s3_bucket.good_bucket.arn}/*",
        ]
      }
    ]
  })

  tags = {
    Environment = var.environment
    Owner       = "platform-team"
    CostCenter  = "challengeA"
  }
}