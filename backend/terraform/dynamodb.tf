/**
 * DynamoDB
 *
 *   Amazon DynamoDB is a fully managed NoSQL database service that provides
 *   fast and predictable performance with seamless scalability.
 *
 *   Local Stack coverage:
 *     https://docs.localstack.cloud/references/coverage/coverage_dynamodb
 *
 *   Local Stack commands:
 *
 *     # List all tables.
 *     awslocal dynamodb list-tables --endpoint-url=http://localhost:4566
 *
 *     # Describe a table.
 *     awslocal dynamodb describe-table --table-name Users --endpoint-url http://localhost:4566
 *
 *     # Put an item into a table.
 *     awslocal dynamodb put-item --table-name Users --item '{"yourKey": {"S": "yourValue"}, "anotherKey": {"N": "123"}}' --endpoint-url http://localhost:4566
 *
 *     # Scan items in a table.
 *     aws dynamodb scan --table-name Users --endpoint-url http://localhost:4566
 *
 *     # Get an item from a table.
 *     awslocal dynamodb get-item --table-name Users --key '{"id": {"S": "550e8400-e29b-41d4-a716-446655440000"}}'
 */

# Provides a DynamoDB table resource.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
resource "aws_dynamodb_table" "users" {
  # (Required) Unique within a region name of the table.
  name = "Users"

  # Controls how you are charged for read and write throughput and how you
  # manage capacity. The valid values are PROVISIONED and PAY_PER_REQUEST.
  # Defaults to PROVISIONED.
  #
  # When optimizing for serverless architecture, the 'pay-per-request'
  # billing option can often be more beneficial. Here's why:
  #
  # - Scalability: In a serverless architecture, your resources should
  #   ideally scale automatically based on demand. Pay-per-request billing
  #   allows DynamoDB to automatically scale up and down to match your
  #   application's traffic patterns. There are no capacity units to manage,
  #   so you can focus on building your applications without worrying about
  #   capacity planning.
  #
  # - Cost-effectiveness: Pay-per-request is a flexible pricing model where
  #   you only pay for what you use. This means that if your application has
  #   inconsistent or unpredictable workloads, or you're just starting up and
  #   don't know your exact capacity requirements, you can avoid
  #   over-provisioning or under-provisioning. This could result in significant
  #   cost savings over time.
  #
  # - Ease of Use: In serverless architectures, the goal is often to reduce
  #   operational overhead. With pay-per-request, there's no need to manage
  #   read/write capacity units, which simplifies configuration and reduces
  #   the need for ongoing management. You only have to monitor the consumed
  #   read/write request units in your AWS billing reports.
  #
  # - Efficiency for Spiky Workloads: If your serverless application has
  #   periods of peak activity interspersed with periods of low or no activity
  #   (i.e., 'spiky' workloads), pay-per-request can be more efficient. You
  #   pay for higher usage during peak times and save money during downtime,
  #   without the need for manual intervention to scale up or down.
  #
  # - Good for Development and Testing: In the early stages of development
  #   and testing, your usage patterns can be highly irregular, making it
  #   hard to predict capacity requirements. Pay-per-request provides the
  #   flexibility to adapt to these changing needs without requiring constant
  #   capacity adjustments.
  billing_mode = "PAY_PER_REQUEST"

  # (Required, Forces new resource) Attribute to use as the hash (partition)
  # key. Must also be defined as an `attribute`.
  hash_key = "id"

  # (Optional, Forces new resource) Attribute to use as the range (sort) key.
  # Must also be defined as an attribute
  #range_key = "email"

  # Storage class of the table. Valid values are STANDARD and
  # STANDARD_INFREQUENT_ACCESS. Default value is STANDARD.
  table_class = "STANDARD"

  # Enables deletion protection for table. Defaults to false.
  deletion_protection_enabled = true

  attribute {
    name = "id"
    type = "S"
  }

  # Whether to enable point-in-time recovery. It can take 10 minutes to
  # enable for new tables. If the point_in_time_recovery block is not
  # provided, this defaults to false.
  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Environment = var.environment
  }
}
