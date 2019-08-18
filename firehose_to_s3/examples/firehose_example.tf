provider "aws" {
  region = "us-east-1"
}

variable "prefix" {}

module "firehose_to_s3" {
  source = "../"
  firehose_name = "test_firehose"
  firehose_policy_name = "test_firehose_policy"
  firehose_role_name = "test_firehose_role"
  bucket_name = "test-firehose-bucket"
  prefix = var.prefix

}

output "firehose_name" {
  value = module.firehose_to_s3.firehose_name
}

output "bucket_name" {
  value = module.firehose_to_s3.bucket_name
}

output "firehose_buffer_interval" {
  value = module.firehose_to_s3.firehose_buffer_interval
}