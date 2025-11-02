global_config = {
  aws_region  = "us-east-1"
  aws_profile = "prim-dev-p8"
  db_prefix = "prim-dev-p8-db"
  environment = "dev"
}

vpc_state_01 = {
  bucket = "prim-dev-p8-terraform"
  key    = "network/terraform.tfstate"
  region = "us-east-1"
}

compute_state_01 = {
  bucket = "prim-dev-p8-terraform"
  key    = "compute/terraform.tfstate"
  region = "us-east-1"
}

####################################################################################################
# RDS Configuration
####################################################################################################
rds_config_01 = {
  count = "01"
  instance = {
    identifier                  = "prim-dev-p8-db-postgres"
    engine                      = "postgres"
    engine_version              = "17.4"
    instance_class              = "db.t3.micro"
    allocated_storage           = 20
    storage_type                = "gp3"
    iops                        = null
    storage_throughput          = null
    port                        = 5432
    username                    = "prim_admin"
    manage_master_user_password = true
  }
  security_group_rules = {
    ingress = [
      {
        description = "Postgres public access"
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    egress = [
      {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
  features = {
    skip_final_snapshot = true
    deletion_protection = true
  }
  maintenance = {
    maintenance_window  = "Mon:00:00-Mon:03:00"
    backup_window       = "03:00-06:00"
    monitoring_interval = 0
  }
  groups = {
    parameter_group_name = "default.postgres17"
    option_group_name    = "default:postgres-17"
  }
  advanced_features = {
    manage_master_user_password         = true
    iam_database_authentication_enabled = false
    performance_insights_enabled        = false
  }
}
