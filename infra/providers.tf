terraform {
  backend "s3" {
    bucket         = "davidrstudios-terraform-state"
    key            = "terraform/davidrstudios.tfstate"
    region         = "us-west-2"
    dynamodb_table = "davidrstudios-terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
