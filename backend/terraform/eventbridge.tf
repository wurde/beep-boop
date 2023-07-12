/**
 * EventBridge
 *
 *   Amazon EventBridge is a serverless event bus service that facilitates the
 *   integration of applications through the handling and routing of events.
 *
 *   Local Stack coverage:
 *     https://docs.localstack.cloud/references/coverage/coverage_events
 *
 */

# # Provides an EventBridge Scheduler Schedule resource.
# # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule
# resource "aws_scheduler_schedule" "example" {
#   # Name of the schedule.
#   name = "example"

#   # Name of the schedule group to associate with this schedule.
#   group_name = "default"

#   # (Required) Configures a time window to invoke the schedule.
#   flexible_time_window {
#     # Determines whether the schedule is invoked within a flexible time window.
#     mode = "OFF"
#   }

#   #  (Required) Defines when the schedule runs.
#   schedule_expression = "rate(1 hours)"

#   # (Required) Configures the target of the schedule.
#   target {
#     # ARN of the target of this schedule
#     arn = aws_lambda.example.arn

#     # ARN of the IAM role that EventBridge Scheduler will use.
#     role_arn = aws_iam_role.example.arn
#   }
# }
