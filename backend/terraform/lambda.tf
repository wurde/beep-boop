/**
 * Lambda
 *
 *   AWS Lambda is a serverless computing service from Amazon Web Services. It
 *   runs developers' code in response to events, automatically managing the
 *   computing resources, and scales applications real-time.
 *
 *   Local Stack coverage:
 *     https://docs.localstack.cloud/references/coverage/coverage_lambda
 *
 *   Local Stack commands:
 *
 *     # List fucntions
 *     awslocal lambda list-functions
 *
 *     # Invoke function
 *     awslocal lambda invoke --function-name do-maths --payload file://temp/events.json outputfile.txt
 */

/**
 * Lambda Functions
 */

# Automatically build all GoLang packages.
# https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource
resource "null_resource" "build_lambdas" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    # usage: go build [-o output] [build flags] [packages]
    #
    # Build compiles the packages named by the import paths,
    # along with their dependencies, but it does not install the results.
    #
    # When compiling packages, build ignores files that end in '_test.go'.
    command = "go build -o ./main -C ../lambdas/do-maths ./main.go"
  }
}

# Zip the GoLang package.
# https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file
data "archive_file" "do_maths" {
  depends_on = [ null_resource.build_lambdas ]

  type        = "zip"
  source_file = "../lambdas/do-maths/main"
  output_path = "../lambdas/do-maths/main.zip"
}

# Define the Lambda function, setting its name, the location of its deployment package,
# the IAM role it should use, and its handler.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function
resource "aws_lambda_function" "do_maths" {
  # The path to the function's deployment package within the local filesystem.
  # This is a .zip of your code (a Go executable) and any dependencies.
  filename = data.archive_file.do_maths.output_path

  # Name of your Lambda function.
  function_name = "do-maths"

  # Description of what your Lambda Function does.
  description = "Evaluate some simple maths."

  # Referencing IAM role defined above.
  role = aws_iam_role.lambda.arn

  # The entry point within your Lambda function.
  handler = "main"

  # The runtime language for your Lambda function.
  # Valid Values: nodejs10.x | nodejs12.x | java8 | java11 | python2.7 |
  # python3.6 | python3.7 | python3.8 | dotnetcore2.1 | dotnetcore3.1 |
  # go1.x | ruby2.5 | ruby2.7 | provided
  runtime = "go1.x"

  # Amount of memory (MB) your Lambda can use at runtime.
  # Between 128 MB to 3,008 MB, in 64 MB increments. Defaults to 128 MB.
  memory_size = 128

  # The amount of time your Lambda Function has to run in seconds.
  # Defaults to 3 with a maximum of 900 seconds (15 minutes).
  timeout = 10

  # To track changes in your deployment package. Triggers updates.
  source_code_hash = data.archive_file.do_maths.output_base64sha256

  environment {
    variables = {
      name = "World"
    }
  }
}

# Link the Kinesis stream to the Lambda function, setting which stream and
# function to use, and specifying that newly added records should be used
# (TRIM_HORIZON)
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping
resource "aws_lambda_event_source_mapping" "kinesis_lambda_mapping" {
  # (Required) ARN of the Kinesis stream.
  event_source_arn = aws_kinesis_stream.main.arn

  # (Required) Name of the Lambda function.
  function_name = aws_lambda_function.do_maths.function_name

  # Reads the most recent data records from the stream. Must be one of
  # AT_TIMESTAMP, LATEST or TRIM_HORIZON.
  starting_position = "TRIM_HORIZON"

  # The largest number of records that Lambda will retrieve from your event
  # source at the time of invocation. Defaults to 100.
  batch_size = 100
}

/**
 * User Sign Up - Group Assignment
 */

# TODO setup group assignment on user sign up.
#
# During the user signup process, a Lambda function is executed to assign
# the user to a group. The pre_sign_up trigger of the User Pool is configured
# to invoke the Lambda function using the lambda_config block of the
# aws_cognito_user_pool resource.
# resource "aws_lambda_function" "assign_group_on_signup" {
#   filename         = "assign_group_on_signup.zip"
#   function_name    = "assignGroupOnSignup"
#   role             = aws_iam_role.lambda_execution_role.arn
#   handler          = "index.handler"
#   runtime          = "nodejs14.x"
#   source_code_hash = filebase64sha256("assign_group_on_signup.zip")
# }

# data "archive_file" "assign_group_on_signup_zip" {
#   type        = "zip"
#   source_file = "lambda_functions/assign_group_on_signup/index.js"
#   output_path = "assign_group_on_signup.zip"
# }

# resource "aws_lambda_permission" "assign_group_on_signup_permission" {
#   statement_id  = "AllowExecutionFromCognito"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.assign_group_on_signup.function_name
#   principal     = "cognito-idp.amazonaws.com"
#   source_arn    = aws_cognito_user_pool.main.arn
# }
