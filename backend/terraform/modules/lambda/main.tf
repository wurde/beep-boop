# Define Lambda resources.
# https://aws.amazon.com/lambda

# Automatically build the Lambda deployment package.
resource "null_resource" "lambda_zip" {
  triggers = {
    source_code_dir = var.source_code_dir
  }

  provisioner "local-exec" {
    command = <<EOF
    cd ${var.source_code_dir} &&
    GOOS=linux go build -o main &&
    zip ../${var.function_name}.zip main
    EOF
  }
}

# https://www.terraform.io/docs/providers/aws/r/lambda_function.html
resource "aws_lambda_function" "query_hello" {
  # The path to the function's deployment package within the local filesystem.
  # This is a .zip of your code (a Go executable) and any dependencies.
  filename = "lambdas/query-hello.zip"

  # A unique name for your Lambda Function.
  function_name = "query-hello"

  # Description of what your Lambda Function does.
  description = "Return a generic welcome message."

  # IAM role attached to the Lambda Function.
  role = aws_iam_role.lambda_query_hello.arn

  # The function entrypoint in your code.
  handler = "query-hello/main"

  # Used to trigger updates.
  source_code_hash = filebase64sha256("lambdas/query-hello.zip")

  # Valid Values: nodejs10.x | nodejs12.x | java8 | java11 | python2.7 |
  # python3.6 | python3.7 | python3.8 | dotnetcore2.1 | dotnetcore3.1 |
  # go1.x | ruby2.5 | ruby2.7 | provided
  runtime = "go1.x"

  # Amount of memory (MB) your Lambda can use at runtime.
  # Between 128 MB to 3,008 MB, in 64 MB increments. Defaults to 128 MB.
  memory_size = 192

  # The amount of time your Lambda Function has to run in seconds.
  # Defaults to 3 with a maximum of 900 seconds (15 minutes).
  timeout = 10
}

/**
 * Lambda
 */

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda.js"
  output_path = "lambda_function_payload.zip"
}

# Provides a Lambda Function resource.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function
resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.test"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs16.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}
