output "rds_01" {
  value = {
    instance_id       = aws_db_instance.postgres_01.id
    endpoint          = aws_db_instance.postgres_01.endpoint
    identifier        = aws_db_instance.postgres_01.identifier
    engine            = aws_db_instance.postgres_01.engine
    engine_version    = aws_db_instance.postgres_01.engine_version
    instance_class    = aws_db_instance.postgres_01.instance_class
    port              = aws_db_instance.postgres_01.port
    security_group_id = aws_security_group.rds_sg_01.id
    master_secret_arn = aws_db_instance.postgres_01.master_user_secret[0].secret_arn
    subnet_group_name = aws_db_subnet_group.db_public_subnet_group_01.name
  }
  description = "RDS 01 instance resources"
}

