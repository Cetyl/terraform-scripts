output "rds_endpoint" {
  description = "RDS endpoint (host)"
  value       = aws_db_instance.postgres.endpoint
}

output "rds_id" {
  description = "RDS instance identifier"
  value       = aws_db_instance.postgres.id
}

output "rds_security_group_id" {
  description = "Security group id used by RDS"
  value       = aws_security_group.rds_sg.id
}

output "rds_master_secret_arn" {
  description = "ARN of the Secrets Manager secret with master credentials"
  value       = aws_db_instance.postgres.master_user_secret[0].secret_arn
}
