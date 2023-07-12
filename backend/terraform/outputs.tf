output "region" {
  description = "AWS region of the resources"
  value       = var.region
}

output "cognito_user_pool_arn" {
  description = "ARN of the user pool."
  value       = aws_cognito_user_pool.main.arn
}

output "cognito_user_pool_endpoint" {
  description = "Endpoint name of the user pool."
  value       = aws_cognito_user_pool.main.endpoint
}

output "cognito_user_pool_id" {
  description = "ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.id
}

output "cognito_client_id" {
  description = "ID of the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.main.id
}

output "api_gateway_url" {
  description = "URL of the API Gateway"
  value       = local.api_gateway_url
}
