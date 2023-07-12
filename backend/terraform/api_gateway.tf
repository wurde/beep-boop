/**
 * API Gateway
 *
 *   AWS API Gateway is a fully managed service offered by Amazon Web Services
 *   (AWS) that makes it easier for developers to create, publish, maintain,
 *   monitor, and secure APIs at any scale. These APIs act as the "front door"
 *   for applications to access data, business logic, or functionality from
 *   your back-end services.
 *
 *   Local Stack coverage:
 *     https://docs.localstack.cloud/references/coverage/coverage_apigateway
 *
 *   Local Stack commands:
 *
 *     # List all Rest APIs
 *     awslocal apigateway get-rest-apis
 *
 *     # Describe a Rest API
 *     awslocal apigateway get-rest-api --rest-api-id YOUR_API_ID
 *
 *     # List all APIs Stages
 *     awslocal apigateway get-stages --rest-api-id YOUR_API_ID
 *
 *     # List all APIs Resources
 *     awslocal apigateway get-resources --rest-api-id YOUR_API_ID
 *
 *     # Get export of an API
 *     awslocal apigateway get-export --rest-api-id YOUR_API_ID --stage-name YOUR_STAGE_NAME --export-type oas30 --accepts application/yaml --no-paginate api.yaml
 *
 *   Other Commands:
 *
 *      # Test CORS via curl
 *      curl -X OPTIONS http://localhost:4566/restapis/API_ID/STAGE_NAME/PATH -v
 *
 *      # Test GET user data via curl
 *      curl -X GET -H "Authorization: Bearer abc123" http://eo671swtjh.execute-api.localhost.localstack.cloud:4566/production/users/550e8400-e29b-41d4-a716-446655440000 -v
 */

# Ensure the OpenAPI specification is prepared before deployment.
resource "null_resource" "openapi_format" {
  provisioner "local-exec" {
    command     = "sed -i -e 's|uri: \"arn:aws:apigateway:[^:]*:|uri: \"arn:aws:apigateway:${var.region}:|' ../../docs/api/openapi.yaml"
    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    command     = "sed -i -e 's|credentials: \"arn:aws:iam::[^:]*:|credentials: \"arn:aws:iam::${local.account_id}:|' ../../docs/api/openapi.yaml"
    interpreter = ["bash", "-c"]
  }
}

# Manages an API Gateway REST API.
#
# WARNING: If the body argument is provided, the OpenAPI specification will
# be used to configure the resources, methods and integrations for the Rest
# API. If this argument is provided, the following resources should not be
# managed as separate ones, as updates may cause manual resource updates to
# be overwritten:
#
# - aws_api_gateway_resource
# - aws_api_gateway_method
# - aws_api_gateway_method_response
# - aws_api_gateway_method_settings
# - aws_api_gateway_integration
# - aws_api_gateway_integration_response
# - aws_api_gateway_gateway_response
# - aws_api_gateway_model
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api
resource "aws_api_gateway_rest_api" "main" {
  # (Required) Name of the REST API.
  name = "main"

  # Description of the REST API.
  description = "My API service."

  # OpenAPI specification that defines the set of routes and integrations.
  # https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-import-api.html
  body = data.local_file.openapi.content

  # API endpoint configuration.
  endpoint_configuration {
    # List of endpoint types. Valid values: EDGE, REGIONAL or PRIVATE.
    types = ["REGIONAL"]
  }

  depends_on = [
    null_resource.openapi_format
  ]
}

# A deployment is a snapshot of the REST API configuration. The deployment can
# then be published to callable endpoints via the aws_api_gateway_stage resource.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment
resource "aws_api_gateway_deployment" "main" {
  # (Required) REST API identifier.
  rest_api_id = aws_api_gateway_rest_api.main.id

  # Triggers a new deployment when the OpenAPI specification changes
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.main.body))
  }

  # Ensure that the new deployment is created before deleting the old one.
  lifecycle {
    create_before_destroy = true
  }

  # A hidden dependency with the Cognito User Pool exists as we use it as
  # an authorizer for the API Gateway (defined in the OpenAPI spec).
  depends_on = [aws_cognito_user_pool.main, aws_cognito_user_pool_client.main]
}

# A stage is a named reference to a deployment.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage
resource "aws_api_gateway_stage" "production" {
  # (Required) ID of the deployment that the stage points to.
  deployment_id = aws_api_gateway_deployment.main.id

  # (Required) ID of the associated REST API.
  rest_api_id = aws_api_gateway_rest_api.main.id

  #(Required) Name of the stage.
  stage_name = "production"
}

# Usage plan for the API Gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_usage_plan
resource "aws_api_gateway_usage_plan" "usage_plan" {
  # Name of the usage plan
  name = "main"

  # Description of the usage plan
  description = "Usage plan for the main API."

  # A quota limit is typically a longer-term restriction, such as how many
  # requests can be made per day, per week, or per month. This is often used
  # as a way to implement tiered pricing levels (e.g., free users get 1000
  # requests per month, premium users get 10,000 requests per month).
  # Exceeding the quota limit usually requires waiting for the reset period
  # (next day, next week, or next month) or upgrading the subscription.
  quota_settings {
    # Maximum number of requests that can be made in a given time period.
    limit = 10000

    # Time period in which the limit applies.
    # Valid values are "DAY", "WEEK" or "MONTH".
    period = "DAY"
  }
}

/**
 * Domain Name Service (DNS)
 */

# # A hosted zone is a container that holds information about how
# # you want to route traffic for a domain, such as example.com,
# # and its subdomains.
# # https://www.terraform.io/docs/providers/aws/r/route53_zone.html
# resource "aws_route53_zone" "domain" {
#   # The DNS name of this hosted zone, for instance "example.com".
#   name = var.domain

#   # Destroy all records in the zone when destroying the zone.
#   force_destroy = true
# }

# # Registers a custom domain name for use with AWS API Gateway.
# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name
# # https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-custom-domains.html
# resource "aws_api_gateway_domain_name" "main" {
#   certificate_arn = aws_acm_certificate_validation.main.certificate_arn
#   domain_name     = var.api_gateway_domain_name
# }

# resource "aws_route53_record" "main" {
#   name    = aws_api_gateway_domain_name.main.domain_name
#   type    = "A"
#   zone_id = aws_route53_zone.domain.id

#   alias {
#     evaluate_target_health = true
#     name                   = aws_api_gateway_domain_name.domain.cloudfront_domain_name
#     zone_id                = aws_api_gateway_domain_name.domain.cloudfront_zone_id
#   }
# }
