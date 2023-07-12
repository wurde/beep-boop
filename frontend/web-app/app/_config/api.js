// eslint-disable-next-line import/no-unresolved, import/extensions, import/no-relative-packages
import { ApiClient, DefaultApi } from '../../lib/api-client/src/index'

// The OpenAPI generator allows creation of client instancese. The generated
// client uses an instance of the server configuration and not the global
// OpenAPI constant. To generate a client instance, set a custom name to the
// client class, use --name option (seen in root package.json).
//
const defaultClient = ApiClient.instance

// Point all requests to the API gateway.
defaultClient.basePath = process.env.NEXT_PUBLIC_API_GATEWAY_URL

// By default 'User-Agent' header is set, but browsers block requests with
// this header set. So we override the default header.
defaultClient.defaultHeaders = {}

// Set the authentication type for Cognito Authorizer.
// defaultClient.authentications.CognitoAuthorizer = {}
// defaultClient.authentications.CognitoAuthorizer.type = 'apiKey'
// defaultClient.authentications.CognitoAuthorizer.name = 'Authorization'
// defaultClient.authentications.CognitoAuthorizer.in   = 'header'
defaultClient.authentications.CognitoAuthorizer.apiKeyPrefix = 'Bearer'

export { ApiClient, DefaultApi }
