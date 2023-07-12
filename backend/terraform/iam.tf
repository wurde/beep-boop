/**
 * Identity and Access Management (IAM)
 *
 *   A web service that helps you securely control access to AWS resources.
 */

/**
 * API Gateway Credentials
 */

# Provides an IAM role.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "apigateway" {
  # Name of the role. If omitted, Terraform will assign a random name.
  name = "APIGatewayRole"

  # (Required) Policy that grants an entity permission to assume the role.
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Provides an IAM role inline policy.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy
resource "aws_iam_role_policy" "dynamodb_access_policy" {
  # Name of the role policy. If omitted, Terraform will assign a random name.
  name = "DynamoDBAccessPolicy"

  # (Required) The name of the IAM role to attach to the policy.
  role = aws_iam_role.apigateway.id

  # (Required) The inline policy document.
  # arn:aws:dynamodb:${Region}:${Account}:${ResourceType}/${ResourcePath}
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:Scan"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:dynamodb:*:*:table/*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "kinesis_access_policy" {
  name   = "KinesisAccessPolicy"
  role   = aws_iam_role.apigateway.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "kinesis:PutItem"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:kinesis:*:*:stream/*"
    }
  ]
}
EOF
}

/**
 * Lambda Policies
 */

# Define an IAM role that the Lambda function can assume.
# The policy allows the Lambda function to call AWS services on your behalf.
# Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "lambda" {
  name = "LambdaRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

/**
 * Cognito Policies
 */

# resource "aws_iam_role" "cognito_role" {
#   name = "CognitoRole"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "cognito-idp.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }

# data "aws_iam_policy_document" "cognito_policy" {
#   statement {
#     actions   = ["cognito-idp:DescribeUserPoolClient"]
#     resources = ["arn:aws:cognito-idp:${var.region}:${local.account_id}:userpool/${aws_cognito_user_pool.main.id}/client/${aws_cognito_user_pool_client.main.id}"]
#   }
# }

# resource "aws_iam_policy" "cognito_policy" {
#   name   = "CognitoPolicy"
#   policy = data.aws_iam_policy_document.cognito_policy.json
# }

# resource "aws_iam_role_policy_attachment" "cognito_role_attachment" {
#   role       = aws_iam_role.cognito_role.name
#   policy_arn = aws_iam_policy.cognito_policy.arn
# }

/**
 * User Policies
 */

# data "aws_iam_policy_document" "api_gateway_policy" {
#   statement {
#     actions   = ["execute-api:Invoke"]
#     resources = ["arn:aws:execute-api:${var.region}:${local.account_id}:${aws_api_gateway_rest_api.main.id}/*"]
#   }
# }

# data "aws_iam_policy_document" "user_policy" {
#   statement {
#     effect    = "Deny"
#     actions   = ["execute-api:Invoke"]
#     resources = ["arn:aws:execute-api:${var.region}:${local.account_id}:${aws_api_gateway_rest_api.main.id}/stage/GET/api/admin/*"]
#   }

#   statement {
#     effect    = "Allow"
#     actions   = ["execute-api:Invoke"]
#     resources = ["arn:aws:execute-api:${var.region}:${local.account_id}:${aws_api_gateway_rest_api.main.id}/stage/GET/api/user/*"]
#   }
# }

# resource "aws_iam_policy" "user_policy" {
#   name   = "UserPolicy"
#   policy = data.aws_iam_policy_document.user_policy.json
# }

/**
 * Admin Policies
 */

# data "aws_iam_policy_document" "admin_policy" {
#   statement {
#     effect    = "Allow"
#     actions   = ["execute-api:Invoke"]
#     resources = ["arn:aws:execute-api:${var.region}:${local.account_id}:${aws_api_gateway_rest_api.main.id}/stage/GET/api/admin/*"]
#   }

#   statement {
#     effect    = "Allow"
#     actions   = ["execute-api:Invoke"]
#     resources = ["arn:aws:execute-api:${var.region}:${local.account_id}:${aws_api_gateway_rest_api.main.id}/stage/GET/api/user/*"]
#   }
# }

# resource "aws_iam_policy" "admin_policy" {
#   name   = "AdminPolicy"
#   policy = data.aws_iam_policy_document.admin_policy.json
# }

/**
 * User Sign Up - Group Assignment
 */

