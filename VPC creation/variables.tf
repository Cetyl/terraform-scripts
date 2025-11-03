variable "project_name" {
  description = "The name of the project (e.g., prim-dev-p8)."
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., dev)."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC (e.g., 10.0.8.0/21)."
  type        = string
}

variable "availability_zones" {
  description = "List of Availability Zones to use (e.g., [us-east-1a, us-east-1b])."
  type        = list(string)
}

variable "web_public_subnets" {
  description = "List of CIDR blocks for web public subnets (paired with AZs)."
  type        = list(string)
}

variable "web_private_subnets" {
  description = "List of CIDR blocks for web private subnets (paired with AZs)."
  type        = list(string)
}

variable "app_private_subnets" {
  description = "List of CIDR blocks for app private subnets (paired with AZs)."
  type        = list(string)
}

variable "database_subnets" {
  description = "List of CIDR blocks for database subnets (paired with AZs)."
  type        = list(string)
}
