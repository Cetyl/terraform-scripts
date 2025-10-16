# Use remote network outputs for subnets and vpc
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.vpc_state_bucket
    key    = var.vpc_state_key
    region = var.vpc_state_region
  }
}

resource "aws_db_instance" "postgres" {
  identifier         = var.rds_identifier
  engine             = var.engine
  engine_version     = var.engine_version
  instance_class     = var.instance_class
  allocated_storage  = var.allocated_storage
  storage_type       = var.storage_type

  # gp3-specific params
  iops               = var.iops
  storage_throughput = var.storage_throughput

  manage_master_user_password         = true
  iam_database_authentication_enabled = false
  port                               = var.port

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  create_db_subnet_group = true
  db_subnet_group_name   = "${var.project_name}-db-subnet-group"
  subnet_ids             = data.terraform_remote_state.network.outputs.pvt_db_sub_ids

  skip_final_snapshot = var.skip_final_snapshot
  deletion_protection = var.deletion_protection

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  monitoring_interval = 0

  parameter_group_name = "default.postgres17"
  option_group_name    = "default:postgres-17"

  performance_insights_enabled = false

  tags = {
    Name        = "${var.project_name}-postgres"
    Environment = var.environment
  }
}
