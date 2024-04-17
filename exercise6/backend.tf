terraform {
  backend "s3" {
    bucket = "tender-test-s3"
    key    = "terraform/backend_exercise6"
    region = "us-east-1"

  }
}