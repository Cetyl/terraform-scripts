####################################################################################################
# Global Configuration
####################################################################################################
global_config = {
  aws_profile = "prim-dev-p8"
  aws_region  = "us-east-1"
}

####################################################################################################
# VPC1 Configuration
####################################################################################################
vpc_01 = {
  count = "01"
  name  = "prim-dev-p8"
  cidr  = "10.0.8.0/21"
  
  # Availability Zones
  availability_zones = ["us-east-1a", "us-east-1b"]
  
  # Public Subnets
  public_subnets = [
    {
      name = "web-public-1a"
      cidr = "10.0.8.0/25"
      az   = "us-east-1a"
    },
    {
      name = "web-public-1b"
      cidr = "10.0.8.128/25"
      az   = "us-east-1b"
    }
  ]
  
  # Private Subnets
  private_web_subnets = [
    {
      name = "web-private-1a"
      cidr = "10.0.9.0/25"
      az   = "us-east-1a"
    },
    {
      name = "web-private-1b"
      cidr = "10.0.9.128/25"
      az   = "us-east-1b"
    }
  ]
  
  private_app_subnets = [
    {
      name = "app-private-1a"
      cidr = "10.0.10.0/23"
      az   = "us-east-1a"
    },
    {
      name = "app-private-1b"
      cidr = "10.0.12.0/23"
      az   = "us-east-1b"
    }
  ]
  
  private_db_subnets = [
    {
      name = "db-private-1a"
      cidr = "10.0.14.0/26"
      az   = "us-east-1a"
    },
    {
      name = "db-private-1b"
      cidr = "10.0.14.64/26"
      az   = "us-east-1b"
    }
  ]
  
  # VPC Features
  enable_dns_support     = true
  enable_dns_hostnames   = true
  enable_nat_gateway     = true
  one_nat_gateway_per_az = true
}

