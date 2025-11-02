variable "global_config" {
  description = "Global configuration settings"
  type = object({
    aws_region  = string
    aws_profile = string
    environment = string
    db_prefix   = string
  })
}

# Remote state configuration
variable "vpc_state_01" {
  description = "VPC remote state configuration"
  type = object({
    bucket = string
    key    = string
    region = string
  })
}

variable "compute_state_01" {
  description = "Compute remote state configuration"
  type = object({
    bucket = string
    key    = string
    region = string
  })
}


# RDS Configuration
variable "rds_config_01" {
  description = "RDS 01 complete configuration"
  type = object({
    count = string

    # RDS Instance Configuration
    instance = object({
      identifier                  = string
      engine                      = string
      engine_version              = string
      instance_class              = string
      allocated_storage           = number
      storage_type                = string
      iops                        = optional(number)
      storage_throughput          = optional(number)
      port                        = number
      username                    = string
      manage_master_user_password = bool
    })

    # Security Group Rules
    security_group_rules = object({
      ingress = list(object({
        description = string
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
      }))
      egress = list(object({
        description = string
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
      }))
    })

    # RDS Features
    features = object({
      skip_final_snapshot = bool
      deletion_protection = bool
    })

    # RDS Maintenance and Monitoring
    maintenance = object({
      maintenance_window  = string
      backup_window       = string
      monitoring_interval = number
    })

    # RDS Parameter and Option Groups
    groups = object({
      parameter_group_name = string
      option_group_name    = string
    })

    # RDS Advanced Features
    advanced_features = object({
      manage_master_user_password         = bool
      iam_database_authentication_enabled = bool
      performance_insights_enabled        = bool
    })
  })
  default = {
    count = "01"
    instance = {
      identifier                  = "prim-dev-p8-db-postgres"
      engine                      = "postgres"
      engine_version              = "17.4"
      instance_class              = "db.t3.micro"
      allocated_storage           = 20
      storage_type                = "gp3"
      iops                        = 3000
      storage_throughput          = 125
      port                        = 5432
      username                    = "prim_admin"
      manage_master_user_password = true
    }
    security_group_rules = {
      ingress = [
        {
          description = "Postgres from within VPC"
          from_port   = 5432
          to_port     = 5432
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/16"]
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
}
