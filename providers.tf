# Provider Configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  alias  = "region1"
  region = "us-west-2" # Choose your preferred region
}
provider "aws" {
  alias  = "region2"
  region = "us-east-1" # Choose your preferred region
}
