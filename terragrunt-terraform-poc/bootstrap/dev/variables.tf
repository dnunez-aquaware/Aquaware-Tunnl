variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "bucket_name" {
  description = "Terraform state bucket"
  type        = string
  default     = "bucket-state-tunnl"
}

variable "lock_table_name" {
  description = "DynamoDB table for state locking"
  type        = string
  default     = "table_lock_tunnl"
}