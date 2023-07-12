# Configure Terraform.

terraform {
  required_providers {
    # https://registry.terraform.io/providers/hashicorp/aws
    aws = {
      source = "hashicorp/aws"
      region = "us-east-1"
    }
  }

  # https://www.terraform.io/docs/backends/types/s3.html
  backend "s3" {
    bucket = "beep-boop"
    region = "us-east-1"
    key    = "terraform.tfstate"
  }

  # https://github.com/hashicorp/terraform
  required_version = ">= 1.4"
}
