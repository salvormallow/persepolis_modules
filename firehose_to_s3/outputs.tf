output "firehose_name" {
  value = aws_kinesis_firehose_delivery_stream.firehose.name
}

output "firehose_arn" {
  value = aws_kinesis_firehose_delivery_stream.firehose.arn
}

output "bucket_name" {
  value = aws_s3_bucket.s3_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.s3_bucket.arn
}

output "firehose_buffer_interval" {
  value = var.firehose_buffer_interval
}
