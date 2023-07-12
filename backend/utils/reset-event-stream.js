// We use the AWS SDK to connect to Kinesis and reset the event stream
// https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/Kinesis.html#putRecord-property
//
// Validate Local Stack via:
//
//   awslocal kinesis list-streams
//
//   awslocal kinesis create-stream --stream-name main --shard-count 1
//
//   awslocal kinesis describe-stream --stream-name main
//
//   awslocal kinesis put-record --stream-name main --partition-key partition-1 --data "Hello World"
//
//   awslocal kinesis get-shard-iterator --shard-id shardId-000000000000 --shard-iterator-type TRIM_HORIZON --stream-name main
//
//   awslocal kinesis get-records --shard-iterator <shard-iterator>
//
//   echo "YourBase64DataHere" | base64 --decode
const AWS = require('aws-sdk')

// Update AWS config to use LocalStack
AWS.config.update({
  region: 'us-east-1',
  endpoint: 'http://0.0.0.0:4566',
})

async function resetEventStream(eventStreamSeed) {
  // Create Kinesis service object
  const kinesis = new AWS.Kinesis()

  for (let i = 0; i < eventStreamSeed.length; i += 1) {
    const params = {
      // The data blob to put into the record, which is base64-encoded when the
      // blob is serialized. When the data blob (the payload before
      // base64-encoding) is added to the partition key size, the total size
      // must not exceed the maximum record size (1 MiB).
      Data: JSON.stringify(eventStreamSeed[i]),

      PartitionKey: 'partition-1',

      // The name of the stream to put the data record into.
      StreamName: 'main',
    }

    // Call Kinesis to put record onto the stream
    try {
      // eslint-disable-next-line no-await-in-loop
      await kinesis.putRecord(params).promise()
    } catch (err) {
      window.console.log(err)
    }
  }
}

module.exports = resetEventStream
