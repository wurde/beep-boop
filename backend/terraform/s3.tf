/**
 * S3
 *
 *   Amazon S3 is a scalable cloud storage service by AWS, offering data
 *   storage and retrieval, backup, archiving, and distribution capabilities.
 *   Its features include unlimited storage, high durability, and detailed
 *   logging.
 *
 *   Local Stack coverage:
 *     https://docs.localstack.cloud/references/coverage/coverage_s3
 *
 *   Local Stack commands:
 *
 *      # List all buckets.
 *      awslocal s3api list-buckets
 *
 *      # List all objects in a bucket.
 *      awslocal s3api list-objects --bucket main-event-store
 *
 *      # Get bucket Ownership Controls.
 *      awslocal s3api get-bucket-ownership-controls --bucket main-event-store
 *
 *      # Get bucket lifecycle configuration.
 *      awslocal s3api get-bucket-lifecycle-configuration --bucket main-event-store
 *
 */

# Provides a S3 bucket resource.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "event_store" {
  # Name of the bucket. Must be lowercase and less than or equal to 63
  # characters in length. Complete list of rules:
  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
  bucket = var.s3_event_store_bucket_name

  # Indicates whether this bucket has an Object Lock configuration enabled.
  object_lock_enabled = true
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration
resource "aws_s3_bucket_object_lock_configuration" "compliance" {
  # (Required) Name of the bucket.
  bucket = aws_s3_bucket.event_store.id

  rule {
    default_retention {
      # (Required) Default Object Lock retention mode you want to apply to
      # new objects placed in this bucket. Valid values are GOVERNANCE and
      # COMPLIANCE.
      #
      # In governance mode, users can't overwrite or delete an object version
      # or alter its lock settings unless they have special permissions. With
      # governance mode, you protect objects against being deleted by most
      # users, but you can still grant some users permission to alter the
      # retention settings or delete the object if necessary. You can also
      # use governance mode to test retention-period settings before creating
      # a compliance-mode retention period.
      #
      # In compliance mode, a protected object version can't be overwritten
      # or deleted by any user, including the root user in your AWS account.
      # When an object is locked in compliance mode, its retention mode can't
      # be changed, and its retention period can't be shortened. Compliance
      # mode helps ensure that an object version can't be overwritten or
      # deleted for the duration of the retention period.
      #
      # https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock-overview.html
      mode = "COMPLIANCE"

      # Number of years to specify for the default retention period.
      years = 9999
    }
  }
}

# S3 Object Ownership is an Amazon S3 bucket-level setting that you can use
# to control ownership of objects uploaded to your bucket and to disable or
# enable access control lists (ACLs). By default, Object Ownership is set to
# the Bucket owner enforced setting and all ACLs are disabled. When ACLs are
# disabled, the bucket owner owns all the objects in the bucket and manages
# access to data exclusively using access management policies.
#
# A majority of modern use cases in Amazon S3 no longer require the use of
# ACLs, and we recommend that you keep ACLs disabled except in unusual
# circumstances where you must control access for each object individually.
# With ACLs disabled, you can use policies to more easily control access to
# every object in your bucket, regardless of who uploaded the objects in your
# bucket.
#
# - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls
# - https://docs.aws.amazon.com/AmazonS3/latest/userguide/about-object-ownership.html
resource "aws_s3_bucket_ownership_controls" "acl_disabled" {
  # (Required) Name of the bucket.
  bucket = aws_s3_bucket.event_store.id

  # (Required) Ownership Controls rules.
  rule {
    # (Required) Object ownership. Valid values: BucketOwnerPreferred,
    # ObjectWriter or BucketOwnerEnforced
    object_ownership = "BucketOwnerEnforced"
  }
}
