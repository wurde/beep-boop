# API Documentation

[<- Back](../README.md)

We maintain two API specifications, one for the event-driven API and one for
the REST API. The event-driven API is documented using the AsyncAPI
specification and the REST API is documented using the OpenAPI specification.

## OpenAPI Documentation

This OpenAPI document is the single source of truth for the configuration
of the Amazon API Gateway. The OpenAPI definition defines routes, methods,
request models, responses, etc., in a standardized, machine-readable format.

### Import into API Gateway

The primary means is to use Terraform, this is just a reference.

```bash
# Via AWS CLI, NOTE: this will overwrite the existing API Gateway configuration.
aws apigateway import-rest-api --parameters endpointConfigurationTypes=REGIONAL --body 'file:///path_to_your_api_definition.yaml'

# Deploy the API Gateway.
aws apigateway create-deployment --rest-api-id abc123 --stage-name 'dev'
```

### Validation

```bash
# Validate that the document conforms to the OpenAPI specification.
openapi validate openapi.yaml
```

Alternatively, use the online Swagger Editor: https://editor.swagger.io
