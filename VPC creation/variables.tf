variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "web_public_subnets" {
  description = "List of public subnets for web tier"
  type        = list(string)
}

variable "web_private_subnets" {
  description = "List of private subnets for web tier"
  type        = list(string)
}

variable "app_private_subnets" {
  description = "List of private subnets for app tier"
  type        = list(string)
}

variable "database_subnets" {
  description = "List of private subnets for database tier"
  type        = list(string)
}