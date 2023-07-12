package main

// Import the required packages. Context and Fmt are standard Go packages.
// The JSON package is used to deal with JSON formatted data. The Events and
// Lambda packages are provided by AWS to work with AWS Lambda functions.
// The govaluate package provides functionality to evaluate string expressions.
//
// - Govaluate: https://github.com/Knetic/govaluate
// - AWS SDK for Go: https://aws.amazon.com/sdk-for-go/
import (
    "fmt"
    "log"
	"context"
	"encoding/json"

	"github.com/Knetic/govaluate"

    "github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

// Define the MathOperation struct to model the data we expect in the Kinesis
// stream. We only expect a single field named "equation" which is a string.
type MathOperation struct {
	Equation string `json:"equation"`
}

// HandleRequest is the main logic of the Lambda function. It receives a
// Kinesis event and a context (which can be used to manage timeouts, among
// other things) and returns a string and an error.
func HandleRequest(ctx context.Context, kinesisEvent events.KinesisEvent) (string, error) {
    // Loop over the Records in the Kinesis event. Each record corresponds to
    // a single data blob in the Kinesis stream.
	for _, record := range kinesisEvent.Records {
        // Extract the Kinesis data from the record.
		kinesisRecord := record.Kinesis

        // Unmarshal the JSON data in the Kinesis record into a MathOperation
        // struct. If the data is not in the expected format, this will return
        // an error.
		var operation MathOperation
		err := json.Unmarshal(kinesisRecord.Data, &operation)
		if err != nil {
			return "", err
		}

        // Create a new evaluable expression with the equation string. This
        // could return an error if the equation string is not a valid
        // expression.
		expression, err := govaluate.NewEvaluableExpression(operation.Equation)
		if err != nil {
			return "", err
		}

        // Evaluate the expression with no parameters. This could return an
        // error if the expression is not valid or if it could not be evaluated.
		result, err := expression.Evaluate(nil)
		if err != nil {
			return "", err
		}

        /**
         * Update DynamoDB table
         */

        // Create new session,
        // AWS region can be configured in AWS Lambda environment variables
        sess, err := session.NewSession()
        if err != nil {
            return "", fmt.Errorf("failed to create session, %v", err)
        }

        // Create new DynamoDB instance
        svc := dynamodb.New(sess)

        // Fixed user ID, replace with securely stored param in production code
        fixedUserID := "550e8400-e29b-41d4-a716-446655440000"

        // Define item attributes. The 'total' field is calculated.
        item := map[string]*dynamodb.AttributeValue{
            "id": {
                S: aws.String(fixedUserID),
            },
            "total": {
                N: aws.String(fmt.Sprintf("%d", result)),
            },
        }

        // Prepare input for UpdateItem operation. We use
        // ExpressionAttributeNames to prevent potential conflicts with
        // DynamoDB reserved words. ExpressionAttributeValues is used to
        // substitute the actual values in our UpdateExpression.
        input := &dynamodb.UpdateItemInput{
            ExpressionAttributeNames: map[string]*string{
                "#T": aws.String("total"),
            },
            ExpressionAttributeValues: map[string]*dynamodb.AttributeValue{
                ":t": {
                    N: aws.String(fmt.Sprintf("%d", result)),
                },
            },
            TableName: aws.String("Users"),
            Key:       item,
            ReturnValues: aws.String("UPDATED_NEW"),
            UpdateExpression: aws.String("SET #T = :t"),
        }

        // Execute UpdateItem operation.
        _, err = svc.UpdateItem(input)
        if err != nil {
            log.Fatalf("Got error updating item: %s", err)
            return "", err
        }

        // Return a string with the result of the operation and no error.
		// The string is formatted with the result value to two decimal places.
		return fmt.Sprintf("The result of the operation is: %.2f", result), nil
	}

    return "", nil
}

// The main function simply starts the lambda function with the handler
// function. When an event is received, the HandleRequest function will be
// invoked.
func main() {
	lambda.Start(HandleRequest)
}
