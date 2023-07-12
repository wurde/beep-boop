# https://registry.terraform.io/providers/hashicorp/aws
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region

  # (Optional) Whether to enable the request to use path-style addressing:
  #   https://s3.amazonaws.com/BUCKET/KEY
  # By default, the S3 client will use virtual hosted bucket addressing:
  #   https://BUCKET.s3.amazonaws.com/KEY
  s3_use_path_style = var.s3_use_path_style

  # (Optional) Whether to skip credentials validation via the STS API. This
  # can be useful for testing and for AWS API implementations that do not
  # have STS available.
  skip_credentials_validation = var.skip_credentials_validation

  # (Optional) Whether to skip the AWS Metadata API check. Useful for AWS
  # API implementations that do not have a metadata API endpoint.
  skip_metadata_api_check = var.skip_metadata_api_check

  # Whether to skip validating the region. Useful for AWS-like implementations
  # that use their own region names or to bypass the validation for regions
  # that aren't publicly available yet.
  skip_region_validation = var.skip_region_validation

  # (Optional) Whether to skip requesting the account ID. Useful for AWS
  # API implementations that do not have the IAM, STS API, or metadata API.
  skip_requesting_account_id = var.skip_requesting_account_id

  # (Optional) Configuration block for customizing service endpoints.
  #
  # The Terraform AWS Provider configuration can be customized to connect to
  # non-default AWS service endpoints and AWS compatible solutions. This may
  # be useful for environments with specific compliance requirements, such
  # as using AWS FIPS 140-2 endpoints, connecting to AWS Snowball, SC2S, or
  # C2S environments, or local testing.
  #
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/custom-service-endpoints
  endpoints {
    apigateway      = var.aws_endpoint
    apigatewayv2    = var.aws_endpoint
    cloudformation  = var.aws_endpoint
    cloudfront      = var.aws_endpoint
    cloudwatch      = var.aws_endpoint
    cognitoidp      = var.aws_endpoint
    cognitosync     = var.aws_endpoint
    cognitoidentity = var.aws_endpoint
    dynamodb        = var.aws_endpoint
    dynamodbstreams = var.aws_endpoint
    ec2             = var.aws_endpoint
    es              = var.aws_endpoint
    elasticache     = var.aws_endpoint
    events          = var.aws_endpoint
    firehose        = var.aws_endpoint
    glacier         = var.aws_endpoint
    iam             = var.aws_endpoint
    kinesis         = var.aws_endpoint
    kms             = var.aws_endpoint
    lambda          = var.aws_endpoint
    neptune         = var.aws_endpoint
    rds             = var.aws_endpoint
    redshift        = var.aws_endpoint
    route53         = var.aws_endpoint
    s3              = var.aws_endpoint
    secretsmanager  = var.aws_endpoint
    ses             = var.aws_endpoint
    sns             = var.aws_endpoint
    sqs             = var.aws_endpoint
    ssm             = var.aws_endpoint
    stepfunctions   = var.aws_endpoint
    sts             = var.aws_endpoint
  }
}
