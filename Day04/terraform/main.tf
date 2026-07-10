############################################
# Package Lambda
############################################

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/handler.py"
  output_path = "${path.module}/lambda.zip"
}

############################################
# CloudWatch Log Group
############################################

resource "aws_cloudwatch_log_group" "lambda" {

  name = "/aws/lambda/${var.lambda_name}"

  retention_in_days = var.log_retention_days

}

############################################
# Lambda Execution Role
############################################

resource "aws_iam_role" "lambda_execution" {
  name = "scheduled-job-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "lambda.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

############################################
# Lambda Logs Policy
############################################

resource "aws_iam_policy" "lambda_logs" {

  name = "scheduled-job-lambda-logs"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]

        Resource = "${aws_cloudwatch_log_group.lambda.arn}:*"
      }

    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {

  role       = aws_iam_role.lambda_execution.name
  policy_arn = aws_iam_policy.lambda_logs.arn
}

############################################
# Lambda Function
############################################

resource "aws_lambda_function" "scheduled_job" {

  function_name = var.lambda_name

  filename = data.archive_file.lambda_zip.output_path

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  role = aws_iam_role.lambda_execution.arn

  handler = "handler.handler"

  runtime = "python3.12"

  depends_on = [
    aws_cloudwatch_log_group.lambda
  ]
}

############################################
# Scheduler Invoke Role
############################################

resource "aws_iam_role" "scheduler" {

  name = "scheduled-job-scheduler-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Principal = {
          Service = "scheduler.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }

    ]
  })
}

############################################
# Scheduler Policy
############################################

resource "aws_iam_policy" "scheduler_invoke" {

  name = "scheduled-job-invoke"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = "lambda:InvokeFunction"

        Resource = aws_lambda_function.scheduled_job.arn

      }

    ]

  })
}

resource "aws_iam_role_policy_attachment" "scheduler" {

  role       = aws_iam_role.scheduler.name
  policy_arn = aws_iam_policy.scheduler_invoke.arn
}

############################################
# EventBridge Scheduler
############################################

resource "aws_scheduler_schedule" "lambda_schedule" {

  name = "scheduled-job"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = var.schedule_expression

  target {

    arn      = aws_lambda_function.scheduled_job.arn
    role_arn = aws_iam_role.scheduler.arn

  }

}