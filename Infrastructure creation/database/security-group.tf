# DB Subnet Group for RDS instance
resource "aws_db_subnet_group" "db_public_subnet_group_01" {
  name       = "${var.global_config.db_prefix}-pub-sub-grp-${var.rds_config_01.count}"
  subnet_ids = data.terraform_remote_state.network.outputs.vpc_01.public_subnet_ids

  tags = merge(local.common_tags_01, {
    Name = "${var.global_config.db_prefix}-pub-sub-grp-${var.rds_config_01.count}"
  })
}