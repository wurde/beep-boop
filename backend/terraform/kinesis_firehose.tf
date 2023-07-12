/**
 * Kinesis Data Firehose
 *
 *   Amazon Kinesis Data Firehose is a fully managed service that makes it
 *   easy to capture, transform, and load streaming data into data stores
 *   and analytical tools. It can automatically scale to handle the throughput
 *   of your data and requires no ongoing administration.
 *
 *   Local Stack coverage:
 *     https://docs.localstack.cloud/references/coverage/coverage_firehose
 *
 *   Local Stack commands:
 *
 *     # Describe the delivery stream
 *     awslocal firehose describe-delivery-stream --delivery-stream-name event-store
 *
 */

# # Provides a Kinesis Firehose Delivery Stream resource.
# #
# # When you configure a Kinesis data stream as the source of a Kinesis Data
# # Firehose delivery stream, the Kinesis Data Firehose PutRecord and
# # PutRecordBatch operations are disabled. To add data to your Kinesis Data
# # Firehose delivery stream in this case, use the Kinesis Data Streams
# # PutRecord and PutRecords operations.
# #
# # Kinesis Data Firehose starts reading data from the LATEST position of your
# # Kinesis stream. It calls the Kinesis Data Streams GetRecords operation once
# # per second for each shard. Each call from any Kinesis Data Firehose delivery
# # stream or other consumer application counts against the overall throttling
# # limit for the Kinesis Data Stream shard.
# #
# # - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream
# # - https://docs.aws.amazon.com/firehose/latest/dev/writing-with-kinesis-streams.html
# resource "aws_kinesis_firehose_delivery_stream" "event_store" {
#   # (Required) A name to identify the stream. This is unique to the AWS
#   # account and region the Stream is created in.
#   name = "event-store"

#   # (Required) This is the destination to where the data is delivered. The
#   # only options are extended_s3, redshift, elasticsearch, splunk,
#   # http_endpoint and opensearch.
#   destination = "extended_s3"

#   # Allows the ability to specify the kinesis stream that is used as the
#   # source of the firehose delivery stream.
#   kinesis_source_configuration {
#     # The kinesis stream used as the source of the firehose delivery stream.
#     kinesis_stream_arn = aws_kinesis_stream.main.arn

#     # The ARN of the role that provides access to the source Kinesis stream.
#     role_arn = aws_iam_role.firehose_role.arn
#   }

#   # Use Amazon S3 as the destination.
#   #
#   # The buffering_size and buffering_interval properties work together to
#   # determine when the data is flushed from the Firehose delivery stream
#   # and delivered to the destination.
#   #
#   #   1) buffering_size: This represents the amount of incoming data to
#   #      accumulate before delivering it to the destination. This value is
#   #      specified in MBs.
#   #
#   #   2) buffering_interval: This represents the length of time for which
#   #      Firehose buffers incoming data before delivering it to the
#   #      destination. This value is specified in seconds.
#   #
#   # Data delivery from the Kinesis Firehose delivery stream occurs when either
#   # the buffering_size is met or the buffering_interval has passed, whichever
#   # happens first.
#   #
#   # https://docs.aws.amazon.com/firehose/latest/dev/create-destination.html#create-destination-s3
#   extended_s3_configuration {
#     # (Required) The ARN of the AWS credentials.
#     role_arn = aws_iam_role.firehose_role.arn

#     # (Required) The ARN of the S3 bucket
#     bucket_arn = aws_s3_bucket.event_store.arn

#     # Buffer incoming data to the specified size, in MBs, before delivering it
#     # to the destination. The default value is 5. We recommend setting
#     # SizeInMBs to a value greater than the amount of data you typically
#     # ingest into the delivery stream in 10 seconds. For example, if you
#     # typically ingest data at 1 MB/sec set SizeInMBs to be 10 MB or higher.
#     buffering_size = 10 # 10 MB

#     # Buffer incoming data for the specified period of time, in seconds,
#     # before delivering it to the destination. The default value is 300.
#     # buffering_interval = 60 # 1 minute
#     buffering_interval = 3600 # 1 hour

#     # The compression format. If no value is specified, the default is
#     # UNCOMPRESSED. Other supported values are GZIP, ZIP, Snappy, &
#     # HADOOP_SNAPPY.
#     compression_format = "UNCOMPRESSED"
#   }
# }

# resource "aws_iam_role" "firehose_role" {
#   name = "firehose_role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "firehose.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy" "firehose_policy" {
#   name = "firehose_policy"
#   role = aws_iam_role.firehose_role.id

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "s3:AbortMultipartUpload",
#         "s3:GetBucketLocation",
#         "s3:GetObject",
#         "s3:ListBucket",
#         "s3:ListBucketMultipartUploads",
#         "s3:PutObject"
#       ],
#       "Resource": [
#         "${aws_s3_bucket.event_store.arn}",
#         "${aws_s3_bucket.event_store.arn}/*"
#       ]
#     }
#   ]
# }
# EOF
# }
