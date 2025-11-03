data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.vpc_state_01.bucket
    key    = var.vpc_state_01.key
    region = var.vpc_state_01.region
  }
}

data "terraform_remote_state" "storage" {
  backend = "s3"
  config = {
    bucket = var.storage_state_01.bucket
    key    = var.storage_state_01.key
    region = var.storage_state_01.region
  }
}

# Optional: containers state for referencing target groups in default action
data "terraform_remote_state" "containers" {
  backend = "s3"
  config = {
    bucket = "prim-dev-p8-terraform"
    key    = "containers/terraform.tfstate"
    region = "us-east-1"
  }
}

# Security state for IAM roles
data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    bucket = var.security_state_01.bucket
    key    = var.security_state_01.key
    region = var.security_state_01.region
  }
}

