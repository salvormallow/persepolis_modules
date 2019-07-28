resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
}

module "lambda_cloudwatch_trigger" {
  source = "../../"

  event_trigger_name = aws_cloudwatch_event_rule.every_five_minutes.name

  lambda_environmental_variables = var.lambda_environmental_variables
  lambda_filename = var.lambda_filename
  lambda_function_name = var.function_name
  lambda_handler = var.lambda_handler
  lambda_policy_name = var.lambda_policy_name
  lambda_policy_template = var.lambda_policy_template
  lambda_policy_variables = {
    "bucket_name" : aws_s3_bucket.s3_bucket.arn
  }
  prefix = var.prefix
}

resource "aws_cloudwatch_event_rule" "every_five_minutes" {
  name = var.event_name
  description = var.event_description
  schedule_expression = var.event_schedule_expression
}
