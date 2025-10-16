project_name       = "prim-dev-p8"
environment        = "dev"
aws_region         = "us-east-1"

# remote state location (uses your working network backend)
vpc_state_bucket   = "prim-dev-p8-terraform"
vpc_state_key      = "network/terraform.tfstate"
vpc_state_region   = "us-east-1"

# optional overrides (defaults are set in variables.tf)
# rds_identifier = "prim-dev-p8-db-postgres"
# instance_class = "db.t3.micro"
# allocated_storage = 20
# iops = 3000
# storage_throughput = 125
