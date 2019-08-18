variable "prefix" {}

variable "firehose_name" {}
variable "firehose_buffer_interval" {
  default = 60
}
variable "firehose_buffer_size" {
  default = 128
}


variable "bucket_name" {}

variable "firehose_role_name" {}
variable "firehose_assume_role_policy_filename" {
  default = "roles/firehose_role.json"
}

variable "firehose_policy_name" {

}
variable "firehose_policy_template" {
  default = "policies/firehose_policy_template.json"
}