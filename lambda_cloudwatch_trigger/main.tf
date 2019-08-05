
resource "aws_lambda_function" "lambda" {
  function_name = "${var.prefix}-${var.lambda_function_name}"
  filename = var.lambda_filename
  handler = var.lambda_handler
  runtime = var.lambda_runtime
  role = aws_iam_role.lambda_role.arn

  environment {
    variables = merge(var.lambda_environmental_variables, {region: data.aws_region.current.name})
  }
}


resource "aws_cloudwatch_event_target" "cloudwatch_lambda_trigger" {
  rule = var.event_trigger_name
  target_id = aws_lambda_function.lambda.function_name
  arn = aws_lambda_function.lambda.arn
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal = "events.amazonaws.com"
  source_arn = var.event_trigger_arn
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.prefix}-${var.lambda_function_name}"
  assume_role_policy = file("${path.module}/${var.lambda_assume_role_policy}")
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.prefix}-${var.lambda_policy_name}"
  role = aws_iam_role.lambda_role.id
  policy = data.template_file.lambda_policy_template.rendered
}

data "template_file" "lambda_policy_template" {
  template = file(var.lambda_policy_template)
  vars = var.lambda_policy_variables
}

data "aws_region" "current" {}