package main

import (
	"context"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func assignGroupOnSignup(ctx context.Context, event events.CognitoEventUserPoolsPostConfirmation) (events.CognitoEventUserPoolsPostConfirmation, error) {
	userGroups := map[string]string{
		"admin@example.com": "Admins",
		"user1@example.com": "Users",
		"user2@example.com": "Users",
		// Add more email-group mappings as needed
	}

	userName := event.Request.UserAttributes["email"]

	// Check if the user's email exists in the mapping
	if group, ok := userGroups[userName]; ok {
		event.Response.AutoConfirmUser = true
		event.Response.AutoVerifyEmail = true
		event.Response.AutoVerifyPhone = true

		event.Response.UserAttributes["custom:group"] = group

		// Add the user to the specified group
		event.UserName = event.Request.UserName
		event.Response.GroupConfiguration = &events.CognitoUserGroupConfiguration{
			GroupsToOverride: []string{group},
			IamRolesToOverride: nil,
			PreferredRole: "",
		}
	}

	return event, nil
}

func main() {
	lambda.Start(assignGroupOnSignup)
}
