data "aws_caller_identity" "current" {
  count = var.environment == "production" ? 1 : 0
}

# The data block for reading the OpenAPI specification file.
data "local_file" "openapi" {
  # The path to the OpenAPI specification file.
  filename = "${path.module}/../../docs/api/openapi.yaml"
}

locals {
  account_id = var.environment == "production" ? data.aws_caller_identity.current[0].account_id : "000000000000"

  # Because we need to change the target URL depending on the environment, we
  # need to use a local variable to dynamically configure the API Gateway URL.
  api_gateway_url      = "${local.api_gateway_protocol}://${aws_api_gateway_rest_api.main.id}.execute-api.${local.api_gateway_region}.${local.api_gateway_domain}/${aws_api_gateway_stage.production.stage_name}"
  api_gateway_protocol = var.environment == "production" ? "https" : "http"
  api_gateway_region   = var.environment == "production" ? var.region : "localhost"
  api_gateway_domain   = var.environment == "production" ? "amazonaws.com" : "localstack.cloud:4566"
}
