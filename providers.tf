terraform {
  #   required_version = ">= 0.12"
  required_providers {
    #   aws = ">= version"
    aws = {
      source = "hashicorp/aws"
    }
  }

}

# Configure the AWS provider
provider "aws" {
  region                  = "us-west-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "Learning"
}
