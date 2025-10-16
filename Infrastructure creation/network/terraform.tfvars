# Project Configuration
project_name = "prim-dev-p8"
environment  = "dev"

# VPC Configuration
vpc_cidr = "10.20.8.0/21"

# Availability Zones
availability_zones = ["us-east-1a", "us-east-1b"]

# Public Subnets
public_subnets = [
  {
    name = "web-public-1a"
    cidr = "10.20.8.0/25"
    az   = "us-east-1a"
  },
  {
    name = "web-public-1b"
    cidr = "10.20.8.128/25"
    az   = "us-east-1b"
  }
]

# Private Subnets
private_subnets = [
  {
    name = "web-private-1a"
    cidr = "10.20.9.0/25"
    az   = "us-east-1a"
  },
  {
    name = "web-private-1b"
    cidr = "10.20.9.128/25"
    az   = "us-east-1b"
  },
  {
    name = "app-private-1a"
    cidr = "10.20.10.0/23"
    az   = "us-east-1a"
  },
  {
    name = "app-private-1b"
    cidr = "10.20.12.0/23"
    az   = "us-east-1b"
  },
  {
    name = "db-private-1a"
    cidr = "10.20.14.0/26"
    az   = "us-east-1a"
  },
  {
    name = "db-private-1b"
    cidr = "10.20.14.64/26"
    az   = "us-east-1b"
  }
]

# VPC Features
enable_dns_support   = true
enable_dns_hostnames = true
enable_nat_gateway   = true
single_nat_gateway   = true
one_nat_gateway_per_az = false