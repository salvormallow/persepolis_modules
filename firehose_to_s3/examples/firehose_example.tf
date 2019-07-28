provider "aws" {
  region = "us-east-1"
}

module "firehose_to_s3" {
  source = "../"
  firehose_name = "test_firehose"
  firehose_policy_name = "test_firehose_policy"
  firehose_role_name = "test_firehose_role"
  bucket_name = "test_firehose_bucket"
  prefix = "test"

}