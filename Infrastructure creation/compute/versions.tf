############################################
# Terraform and provider version constraints
############################################
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

}

provider "aws" {
  region = var.global_config.aws_region
}

