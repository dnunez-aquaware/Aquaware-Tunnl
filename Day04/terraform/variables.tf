variable "lambda_name" {

  description = "Name of the Lambda function"

  type = string

  default = "scheduled-job"

}


variable "schedule_expression" {

  description = "EventBridge Scheduler expression"

  type = string

  default = "rate(1 minute)"

}


variable "log_retention_days" {

  description = "CloudWatch retention period"

  type = number

  default = 7

}


variable "environment" {

  description = "Environment name"

  type = string

  default = "training"

}