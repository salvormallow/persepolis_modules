resource "aws_kinesis_firehose_delivery_stream" "firehose" {
  name = "${var.prefix}-${var.firehose_name}"
  destination = "extended_s3"
  extended_s3_configuration {
    role_arn = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.s3_bucket.arn
    buffer_size = var.firehose_buffer_size
    buffer_interval = var.firehose_buffer_interval
  }
}

resource "aws_iam_role" "firehose_role" {
  name = "${var.prefix}-${var.firehose_role_name}"
  assume_role_policy = file("${path.module}/${var.firehose_assume_role_policy_filename}")
}

resource "aws_iam_role_policy" "firehose_policy" {
  name = "${var.prefix}-${var.firehose_policy_name}"
  role = aws_iam_role.firehose_role.id
  policy = data.template_file.firehose_policy_template.rendered
}

data "template_file" "firehose_policy_template" {
  template = file("${path.module}/${var.firehose_policy_template}")
  vars = {
    bucket_arn = aws_s3_bucket.s3_bucket.arn
  }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.prefix}-${var.bucket_name}"
}
