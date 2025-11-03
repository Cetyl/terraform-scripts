data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.vpc_state_01.bucket
    key    = var.vpc_state_01.key
    region = var.vpc_state_01.region
  }
}

data "terraform_remote_state" "compute" {
  backend = "s3"
  config = {
    bucket = var.compute_state_01.bucket
    key    = var.compute_state_01.key
    region = var.compute_state_01.region
  }
}