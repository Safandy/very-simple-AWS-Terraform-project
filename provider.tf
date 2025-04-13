provider "aws" {
  region = "us-east-1"
  access_key = "##"  # Replace this with your Access key
  secret_key = "##" # Replace this with your secret key
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

