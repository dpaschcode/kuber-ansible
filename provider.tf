terraform {
required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "4.62.0"
    }
  }
}

# Configure the AWS Provider
  provider "aws" {
    region = "us-east-1"
    profile = "student.4"
}