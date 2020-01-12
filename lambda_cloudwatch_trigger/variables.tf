variable "prefix" {}

variable "lambda_function_name" {}
variable "lambda_filename" {}
variable "lambda_handler" {
  default = "main"
}
variable "lambda_runtime" {
  default = "go1.x"
}
variable "lambda_environmental_variables" {
  type = map(string)
}

variable "event_trigger_name" {}
variable "event_trigger_arn" {}

variable "lambda_assume_role_policy" {
  default = "roles/lambda_role.json"
}
variable "lambda_policy_name" {}
variable "lambda_policy_template" {}
variable "lambda_policy_variables" {}
