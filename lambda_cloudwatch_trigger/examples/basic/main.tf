variable "prefix" {}

module "lambda_cloudwatch_trigger" {
  source = "../../"
  lambda_function_name = "test_lambda_function"
  event_trigger_name = aws_cloudwatch_event_rule.every_five_minutes.name
  event_trigger_arn = aws_cloudwatch_event_rule.every_five_minutes.arn

  lambda_environmental_variables = {

  }
  lambda_filename = "resources/main.zip"

  lambda_policy_name = "test_lambda_function"
  lambda_policy_template = "resources/policy.json"
  lambda_policy_variables = {
  }
  prefix = var.prefix
}

resource "aws_cloudwatch_event_rule" "every_five_minutes" {
  name = "${var.prefix}-every-five-minutes"
  description = "Fires every five minutes"
  schedule_expression = "rate(5 minutes)"
}

output "region" {
  value = module.lambda_cloudwatch_trigger.region
}

output "lambda_function_name" {
  value = module.lambda_cloudwatch_trigger.lambda_function_name
}