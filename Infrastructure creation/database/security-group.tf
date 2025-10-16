# read network outputs from network remote state
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.vpc_state_bucket
    key    = var.vpc_state_key
    region = var.vpc_state_region
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-rds-sg"
  description = "RDS security group for ${var.project_name}"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  # restrict to your VPC internal CIDR. If your network outputs vpc_cidr, use it; otherwise adjust.
  ingress {
    description = "Postgres from within VPC"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-rds-sg"
    Environment = var.environment
  }
}
