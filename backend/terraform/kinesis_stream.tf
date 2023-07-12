/**
 * Kinesis Data Stream
 *
 *   Amazon Kinesis Data Streams (KDS) is a massively scalable and durable
 *   real-time data streaming service.
 *
 *   Local Stack coverage:
 *     https://docs.localstack.cloud/references/coverage/coverage_kinesis
 *
 *     awslocal kinesis create-stream --stream-name main --shard-count 1
 *
 *     awslocal kinesis list-streams
 *
 *     awslocal kinesis put-record --stream-name main --data "testData" --partition-key 123
 *
 *     awslocal kinesis get-shard-iterator --stream-name main --shard-id shardId-000000000000 --shard-iterator-type TRIM_HORIZON
 *
 *     awslocal kinesis get-records --shard-iterator YourShardIterator
 *
 *     # NOTE: the data is base64 encoded
 *     echo "dGVzdERhdGE=" | base64.exe --decode
 *     #=> testData
 *
 *   Sample Kinesis records (what Lambda sees):
 *
 *     {
 *      "Records": [
 *        {
 *          "kinesis": {
 *            "kinesisSchemaVersion": "1.0",
 *            "partitionKey": "partition-1",
 *            "sequenceNumber": "49545115243490985018280067714973144582180062593244200961",
 *            "data": "eyJlcXVhdGlvbiI6ICIzKzUifQo=",
 *            "approximateArrivalTimestamp": 1428537600
 *          },
 *          "eventSource": "aws:kinesis",
 *          "eventVersion": "1.0",
 *          "eventID": "shardId-000000000006:49545115243490985018280067714973144582180062593244200961",
 *          "eventName": "aws:kinesis:record",
 *          "invokeIdentityArn": "arn:aws:iam::EXAMPLE",
 *          "awsRegion": "us-east-1",
 *          "eventSourceARN": "arn:aws:kinesis:us-east-1:000000000000:stream/main"
 *        }
 *      ]
 *    }
 */

# Provides a Kinesis Stream resource.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream
resource "aws_kinesis_stream" "main" {
  # (Required) A name to identify the stream.
  name = "main"

  # (Required, if PROVISIONED) The number of shards that the stream will use.
  shard_count = 1

  # Length of time (hours) records are accessible after they are added.
  retention_period = 72

  # A list of shard-level CloudWatch metrics which can be enabled for the stream.
  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  # A boolean that indicates all registered consumers should be deregistered
  # from the stream so that the stream can be destroyed without error.
  enforce_consumer_deletion = true

  # The encryption type to use.
  encryption_type = "NONE"

  # Indicates the capacity mode of the data stream.
  stream_mode_details {
    # Must be either PROVISIONED or ON_DEMAND.
    # stream_mode = "ON_DEMAND"
    stream_mode = "PROVISIONED"
  }
}
