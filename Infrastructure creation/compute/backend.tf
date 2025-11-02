############################################
# Backend configuration for state storage
############################################

terraform {
  backend "s3" {
    bucket       = "prim-dev-p8-terraform"
    key          = "compute/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}