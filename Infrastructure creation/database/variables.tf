variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "prim-dev-p8"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

# Remote state location for the network module
variable "vpc_state_bucket" {
  description = "S3 bucket that stores network terraform state"
  type        = string
  default     = "prim-dev-p8-terraform"
}

variable "vpc_state_key" {
  description = "Key/path to the network terraform state file"
  type        = string
  default     = "network/terraform.tfstate"
}

variable "vpc_state_region" {
  description = "Region of the remote state S3 bucket"
  type        = string
  default     = "us-east-1"
}

# RDS specifics (exposed so you can override in tfvars)
variable "rds_identifier" {
  description = "RDS identifier"
  type        = string
  default     = "prim-dev-p8-db-postgres"
}

variable "engine" {
  description = "DB engine"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "DB engine version"
  type        = string
  default     = "17.4"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Storage (GiB)"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type"
  type        = string
  default     = "gp3"
}

variable "iops" {
  description = "IOPS for gp3"
  type        = number
  default     = 3000
}

variable "storage_throughput" {
  description = "Throughput for gp3 in MiB/s"
  type        = number
  default     = 125
}

variable "port" {
  description = "DB port"
  type        = number
  default     = 5432
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on destroy"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}
