// https://www.npmjs.com/package/aws-amplify
import { Amplify } from 'aws-amplify'

// If NOT production, then configure to use Local Stack
//
// Avoids having to use this broken POS package:
// https://github.com/localstack/amplify-js-local/blob/main/lib/es6.js
//
// Modifications are made to the AuthClass above:
// https://github.com/aws-amplify/amplify-js/blob/main/packages/auth/src/Auth.ts
if (process.env.NODE_ENV !== 'production') {
  // https://docs.amplify.aws/lib/auth/getting-started/q/platform/js
  Amplify.configure({
    Auth: {
      // REQUIRED - Amazon Cognito Region
      region: process.env.NEXT_PUBLIC_REGION,

      // OPTIONAL - Amazon Cognito User Pool ID
      userPoolId: process.env.NEXT_PUBLIC_COGNITO_USER_POOL_ID,

      // OPTIONAL - Amazon Cognito Web Client ID (26-char alphanumeric string)
      userPoolWebClientId: process.env.NEXT_PUBLIC_COGNITO_CLIENT_ID,

      // OPTIONAL - Patch to use local endpoint
      endpoint: 'http://localhost:4566',
    },
  })
} else {
  Amplify.configure({
    Auth: {
      region: process.env.NEXT_PUBLIC_REGION,
      userPoolId: process.env.NEXT_PUBLIC_COGNITO_USER_POOL_ID,
      userPoolWebClientId: process.env.NEXT_PUBLIC_COGNITO_CLIENT_ID,
    },
  })
}
