terraform {
  backend "s3" {
    bucket       = "prim-dev-tf-statefile"
    key          = "network/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}