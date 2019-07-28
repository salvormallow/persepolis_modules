variable "bucket_name" {}

variable "function_name" {}
variable "lambda_handler" {}
variable "lambda_filename" {}
variable "lambda_policy_name" {}
variable "lambda_policy_template" {}
variable "lambda_runtime" {}
variable "lambda_environmental_variables" {
  type = "map"
}
variable "prefix" {}

variable "event_name" {}
variable "event_description" {}
variable "event_schedule_expression" {}