# "https://api.example.com/service"
variable "api_gateway_domain_name" {}

variable "environment" {
  default = "dev"
}

variable "region" {
  default = "us-east-1"
}

/**
 * Local Stack
 */

variable "access_key" {}
variable "secret_key" {}
variable "s3_use_path_style" {}
variable "skip_credentials_validation" {}
variable "skip_metadata_api_check" {}
variable "skip_region_validation" {}
variable "skip_requesting_account_id" {}
variable "aws_endpoint" {}

/**
 * S3
 */

variable "s3_event_store_bucket_name" {}
