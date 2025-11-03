terraform {
  backend "s3" {
    bucket       = "prim-dev-tf-statefile-1"
    key          = "storage/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}