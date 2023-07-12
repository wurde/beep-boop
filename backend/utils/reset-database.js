// We use the AWS SDK to connect to DynamoDB and reset the database
// https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/DynamoDB/DocumentClient.html#put-property
// https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_AttributeValue.html
//
//   {
//     "TableName": "<TableName>",
//     "Item": {
//        "HashKey": { "S": "haskey"},
//        "NumAttribute": {"N": "1"},
//        "BoolAttribute": {"BOOL": "true"},
//        "ListAttribute": {"L": [{"N": "1"}, {"S": "two"}, {"BOOL": "false"}]},
//        "MapAttribute": {"M": "{"foo": "bar"}"},
//        "NullAttribute": {"NULL": "null"}
//     }
//   }
//
// Validate Local Stack via:
//
//   awslocal dynamodb list-tables
//
//   awslocal dynamodb create-table --table-name Users --attribute-definitions AttributeName=userId,AttributeType=S --key-schema AttributeName=userId,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
//
//   awslocal dynamodb describe-table --table-name Users
//
//   awslocal dynamodb scan --table-name Users
const AWS = require('aws-sdk')

// Update AWS config to use LocalStack
AWS.config.update({
  region: 'us-east-1',
  endpoint: new AWS.Endpoint('http://0.0.0.0:4566'),
})

function resetDatabase(databaseSeed) {
  // Create DynamoDB service object
  const ddb = new AWS.DynamoDB.DocumentClient()

  for (let i = 0; i < databaseSeed.length; i += 1) {
    // Call DynamoDB to add the item to the table
    ddb.put(databaseSeed[i], err => {
      if (err) window.console.log(err)
    })
  }
}

module.exports = resetDatabase
