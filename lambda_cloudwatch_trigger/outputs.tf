output "region" {
  value = data.aws_region.current.name
}

output "lambda_function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "lambda_version_name" {
  value = aws_lambda_function.lambda.version
}