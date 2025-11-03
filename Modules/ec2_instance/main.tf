terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0" # Specify the version that suits your needs
    }
  }
}

provider "aws" {
  region = var.region_value
}

resource "aws_instance" "nest" {
  ami           = var.ami_value
  instance_type = var.instance_type_value

  tags = {
    Name = "test_instance_3"
  }
}

