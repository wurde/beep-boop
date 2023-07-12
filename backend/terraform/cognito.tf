/**
 * Cognito
 *
 *   Provides simple and secure user identity and data synchronization
 *   service that helps you create, manage, and secure user access for
 *   your applications across multiple devices
 *
 *   Local Stack coverage:
 *     https://docs.localstack.cloud/references/coverage/coverage_cognito-idp
 *
 *   Local Stack commands:
 *
 *     # List user pools
 *     awslocal cognito-idp list-user-pools --max-results 10
 *
 *     # Describe a user pool
 *     awslocal cognito-idp describe-user-pool --user-pool-id YOUR_USER_POOL_ID
 *
 *     # List users in a user pool
 *     awslocal cognito-idp list-users --user-pool-id YOUR_USER_POOL_ID
 *
 *     # Confirm user signup
 *     awslocal cognito-idp admin-confirm-sign-up --user-pool-id YOUR_USER_POOL_ID --username phantomassembly@gmail.com
 *
 *     # Admin create user
 *     awslocal cognito-idp admin-create-user --user-pool-id YOUR_USER_POOL_ID --username YOUR_USERNAME --user-attributes Name=email,Value=YOUR_EMAIL --temporary-password <tempPassword> --message-action SUPPRESS
 *
 *     # Admin get user
 *     awslocal cognito-idp admin-get-user --user-pool-id YOUR_USER_POOL_ID --username YOUR_USERNAME --endpoint-url http://localhost:4566
 *
 *     # List user pool clients
 *     awslocal cognito-idp list-user-pool-clients --user-pool-id YOUR_USER_POOL_ID --region YOUR_REGION
 *
 *     # Describe user pool client
 *     awslocal cognito-idp describe-user-pool-client --user-pool-id YOUR_USER_POOL_ID --client-id YOUR_CLIENT_ID
 */

# You can stream the following user events to Kinesis:
#
# - SignUp: Triggers when a user who does not exist in the user pool signs up.
# - SignIn: Triggers when an existing user signs in.
# - AdminSignIn: Triggers when a user sign-in is initiated by an admin of the user pool.
# - ForgotPassword: Triggers when a user initiates a password recovery.
# - UpdateUserAttribute: Triggers when any user attribute has been modified.
# - DeleteUserAttribute: Triggers when a user attribute has been deleted.
# - UnblockUser: Triggers when an administrator unblocks a previously blocked user.
# - AdminCreateUser: Triggers when an admin creates a new user.
# - AdminUpdateUserAttribute: Triggers when an admin updates a user attribute.
# - AdminDeleteUserAttribute: Triggers when an admin deletes a user attribute.
# - AdminDisableUser: Triggers when an admin disables a user.
# - AdminEnableUser: Triggers when an admin enables a user.
# - AdminResetUserPassword: Triggers when an admin resets a user's password.
# - UserMigration: Triggers when a user is migrated from a user pool.
# - MfaEnrollment: Triggers when a user enrolls in MFA.
# - MfaCompromise: Triggers when there's a suspicion that MFA might have been compromised.
# - PasswordChange: Triggers when a user changes their password.
# - RefreshTokenRevoke: Triggers when a refresh token has been revoked.
# - UserNotConfirmed: Triggers when a user, who has signed up but not confirmed, tries to sign in.
# - AdminRespondToAuthChallenge: Triggers when an admin responds to an auth challenge.
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool
resource "aws_cognito_user_pool" "main" {
  # (Required) Name of the user pool.
  name = "main"

  # Configuration block for information about the user pool password policy.
  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  schema {
    # (Required) Attribute data type.
    # Must be one of Boolean, Number, String, DateTime.
    attribute_data_type = "String"

    # (Required) Name of the attribute.
    name = "email"

    # Whether the attribute type is developer only.
    developer_only_attribute = false

    # Whether the attribute can be changed once it has been created.
    mutable = false

    # Whether a user pool attribute is required. If the attribute is
    # required and the user does not provide a value, registration or sign-in
    # will fail.
    required = true

    # (Required when attribute_data_type is String) Constraints for an
    # attribute of the string type.
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  # Multi-Factor Authentication (MFA) configuration for the User Pool.
  # Defaults to OFF. Valid values are OFF, ON, and OPTIONAL.
  mfa_configuration = "OFF"

  # Whether email addresses or phone numbers can be specified as usernames
  # when a user signs up. Conflicts with alias_attributes.
  username_attributes = ["email"]

  # Attributes to be auto-verified. Valid values: email, phone_number.
  auto_verified_attributes = ["email"]

  # User signup process invokes a Lambda function to assign the user to a group.
  #lambda_config {
  #  pre_sign_up = aws_lambda_function.assign_group_on_signup.arn
  #}

  # Allow to customize identity token claims before token generation.
  #lambda_config {
  #  pre_token_generation = aws_iam_role.cognito_role.arn
  #}

  provisioner "local-exec" {
    # (Required) This is the command to execute.
    command = "sed -i -e 's|\"arn:aws:cognito-idp.*\"|\"${self.arn}\"|' ../../docs/api/openapi.yaml"

    # List of interpreter arguments used to execute the command.
    interpreter = ["bash", "-c"]
  }
}

# A client-side application that interacts with a user pool. When using AWS
# Cognito, a UserPoolClient is needed to make unauthenticated requests to
# sign up and log in users in your app. This is especially crucial in React
# where these operations occur.
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client
resource "aws_cognito_user_pool_client" "main" {
  # (Required) Name of the application client.
  name = "main"

  # (Required) User pool the client belongs to.
  user_pool_id = aws_cognito_user_pool.main.id

  # List of authentication flows:
  # - ADMIN_NO_SRP_AUTH: This authentication flow is used for server-side
  #   authentication, where the SRP (Secure Remote Password protocol)
  #   password verifier is not used. In this flow, the server administrator
  #   sends the username and password to AWS Cognito for authentication. This
  #   flow should only be used when the admin has securely obtained the user's
  #   credentials.
  #
  # - CUSTOM_AUTH_FLOW_ONLY: This flow is for when the developer has
  #   implemented a custom authentication flow in AWS Lambda. The flow can
  #   include a series of challenge/response cycles.
  #
  # - USER_PASSWORD_AUTH: This flow authenticates users directly by verifying
  #   their username and password. Users provide their username and password
  #   directly to AWS Cognito, which validates them and returns the tokens.
  #
  # - ALLOW_ADMIN_USER_PASSWORD_AUTH: This flag allows the server admin to
  #   start a password challenge when an "Admin Initiate Auth" request is
  #   made. It's similar to ADMIN_NO_SRP_AUTH but leverages a user password
  #   for initiating the authentication.
  #
  # - ALLOW_CUSTOM_AUTH: This allows the custom authentication flow to be used
  #   with the "Initiate Auth" and "Respond To Auth Challenge" APIs.
  #
  # - ALLOW_USER_PASSWORD_AUTH: This enables the client to directly
  #   authenticate, in addition to SRP. It allows users to supply username
  #   and password to AWS Cognito directly in the "Initiate Auth" API call.
  #
  # - ALLOW_USER_SRP_AUTH: This allows the Secure Remote Password (SRP)
  #   protocol based authentication. In this flow, the user's password is
  #   never sent or stored by the server. Instead, a password verifier is used.
  #
  # - ALLOW_REFRESH_TOKEN_AUTH: This allows the refresh token flow, where the
  #   app exchanges a refresh token for new access and ID tokens. It's used
  #   when the previous tokens are expired, and you want to get new ones
  #   without forcing the user to sign in again.
  explicit_auth_flows = [
    "USER_PASSWORD_AUTH"
  ]

  # Should an application secret be generated.
  #
  # A client secret is a fixed string that your app must use in all API
  # requests to the app client. Your app client must have a client secret
  # to perform client_credentials grants.
  #
  # You can't change secrets after you create an app. You can create a new
  # app with a new secret if you want to rotate the secret. You can also
  # delete an app to block access from apps that use that app client ID.
  generate_secret = false

  # List of identity providers that are supported on this client.
  supported_identity_providers = ["COGNITO"]
}

# Provides a Cognito User Group resource.
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_group
# resource "aws_cognito_user_group" "admins_group" {
#   # (Required) The name of the user group.
#   name = "Admins"

#   # (Required) The user pool ID.
#   user_pool_id = aws_cognito_user_pool.main.id
# }

# resource "aws_cognito_user_group" "users_group" {
#   name         = "Users"
#   user_pool_id = aws_cognito_user_pool.main.id
# }
