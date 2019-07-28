bucket_name = "persepolis-test-lambda-bucket"

function_name = "test_lambda_function"
lambda_handler = "test_lambda_function.main"
lambda_filename = "./"
lambda_policy_name = "test_lambda_function"


event_name = "every-five-minutes"
event_description = "Fires every five minutes"
event_schedule_expression = "rate(5 minutes)"