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

//output "firehose_buffer_size" {
//  value = aws_kinesis_firehose_delivery_stream.firehose.extended_s3_configuration.buffer_size
//}
//
//output "firehose_buffer_interval" {
//  value = aws_kinesis_firehose_delivery_stream.firehose.extended_s3_configuration.buffer_interval
//}