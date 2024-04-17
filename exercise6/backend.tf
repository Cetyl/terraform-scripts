terraform {
  backend "s3" {
    bucket = "tender-test2-s3"
    key    = "terraform/backend_exercise6"
    region = "us-east-1"

  }
}