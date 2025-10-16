variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for resources"
}

variable "project_name" {
  type        = string
  description = "Name of the project (e.g., prim-dev-p8)"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, staging, prod)"
}


variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "public_subnets" {
  type = list(object({
    name = string
    cidr = string
    az   = string
  }))
  description = "List of public subnets"
}

variable "private_subnets" {
  type = list(object({
    name = string
    cidr = string
    az   = string
  }))
  description = "List of private subnets"
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "Enable DNS support in VPC"
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "Enable DNS hostnames in VPC"
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Enable NAT Gateway for private subnets"
}

variable "single_nat_gateway" {
  type        = bool
  default     = true
  description = "Use single NAT Gateway for all private subnets"
}

variable "one_nat_gateway_per_az" {
  type        = bool
  default     = false
  description = "Create one NAT Gateway per availability zone"
}