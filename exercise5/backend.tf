terraform {
  backend "s3" {
    bucket = "terra1-test-s3"
    key = "terraform/backend"
    region = "us-east-1"
    
  }
}