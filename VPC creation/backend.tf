terraform {
  backend "s3" {
    bucket       = "prim-dev-tf-statefile-1"
    key          = "network/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}