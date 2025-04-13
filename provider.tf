provider "aws" {
  region = "us-east-1"
  access_key = "AKIAQR5EPF6XBE74ZWVW"  # Replace this with your Access key
  secret_key = "QW6i0EF0wKqnQ9izkzxqPz61vDGRC55HXNFb3CJC" # Replace this with your secret key
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

