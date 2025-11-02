# RDS PostgreSQL Instance
resource "aws_db_instance" "postgres_01" {
  username                    = var.rds_config_01.instance.username
  manage_master_user_password = var.rds_config_01.advanced_features.manage_master_user_password
  identifier                  = "${var.rds_config_01.instance.identifier}-${var.rds_config_01.count}"
  engine                      = var.rds_config_01.instance.engine
  engine_version              = var.rds_config_01.instance.engine_version
  instance_class              = var.rds_config_01.instance.instance_class
  allocated_storage           = var.rds_config_01.instance.allocated_storage
  storage_type                = var.rds_config_01.instance.storage_type

  # gp3-specific parameters (only set if not null)
  iops               = var.rds_config_01.instance.iops
  storage_throughput = var.rds_config_01.instance.storage_throughput

  iam_database_authentication_enabled = var.rds_config_01.advanced_features.iam_database_authentication_enabled
  port                                = var.rds_config_01.instance.port
  publicly_accessible                 = true

  vpc_security_group_ids = [aws_security_group.rds_sg_01.id]

  db_subnet_group_name = aws_db_subnet_group.db_public_subnet_group_01.name

  skip_final_snapshot = var.rds_config_01.features.skip_final_snapshot
  deletion_protection = var.rds_config_01.features.deletion_protection

  maintenance_window = var.rds_config_01.maintenance.maintenance_window
  backup_window      = var.rds_config_01.maintenance.backup_window

  monitoring_interval = var.rds_config_01.maintenance.monitoring_interval

  parameter_group_name = var.rds_config_01.groups.parameter_group_name
  option_group_name    = var.rds_config_01.groups.option_group_name

  performance_insights_enabled = var.rds_config_01.advanced_features.performance_insights_enabled

  tags = merge(local.common_tags_01, {
    Name = "${var.rds_config_01.instance.identifier}-${var.rds_config_01.count}"
  })
}

resource "aws_security_group" "rds_sg_01" {
  name        = "${var.rds_config_01.instance.identifier}-sg-${var.rds_config_01.count}"
  description = "Security group for RDS instance"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_01.vpc_id

  tags = {
    Name        = "${var.rds_config_01.instance.identifier}-sg-${var.rds_config_01.count}"
    Environment = var.global_config.environment
    Tier        = "Database"
  }
}

resource "aws_security_group_rule" "rds_ingress_rules_01" {
  count = length(var.rds_config_01.security_group_rules.ingress)

  type              = "ingress"
  from_port         = var.rds_config_01.security_group_rules.ingress[count.index].from_port
  to_port           = var.rds_config_01.security_group_rules.ingress[count.index].to_port
  protocol          = var.rds_config_01.security_group_rules.ingress[count.index].protocol
  cidr_blocks       = var.rds_config_01.security_group_rules.ingress[count.index].cidr_blocks
  description       = var.rds_config_01.security_group_rules.ingress[count.index].description
  security_group_id = aws_security_group.rds_sg_01.id
}

# Additional rule to allow compute security group access to port 5432
resource "aws_security_group_rule" "rds_compute_ingress_01" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = data.terraform_remote_state.compute.outputs.ec2_01.security_group_id
  description              = "Postgres access from compute security group"
  security_group_id        = aws_security_group.rds_sg_01.id
}

resource "aws_security_group_rule" "rds_egress_rules_01" {
  count = length(var.rds_config_01.security_group_rules.egress)

  type              = "egress"
  from_port         = var.rds_config_01.security_group_rules.egress[count.index].from_port
  to_port           = var.rds_config_01.security_group_rules.egress[count.index].to_port
  protocol          = var.rds_config_01.security_group_rules.egress[count.index].protocol
  cidr_blocks       = var.rds_config_01.security_group_rules.egress[count.index].cidr_blocks
  description       = var.rds_config_01.security_group_rules.egress[count.index].description
  security_group_id = aws_security_group.rds_sg_01.id
}

