variable "global_config" {
  type = object({
    aws_profile = string
    aws_region  = string
  })
  description = "Global configuration settings"
}

variable "vpc_01" {
  type = object({
    count = string
    name  = string
    cidr  = string
    
    # Availability Zones
    availability_zones = list(string)
    
    # Public Subnets
    public_subnets = list(object({
      name = string
      cidr = string
      az   = string
    }))
    
    # Private Subnets
    private_web_subnets = list(object({
      name = string
      cidr = string
      az   = string
    }))
    
    private_app_subnets = list(object({
      name = string
      cidr = string
      az   = string
    }))
    
    private_db_subnets = list(object({
      name = string
      cidr = string
      az   = string
    }))
    
    # VPC Features
    enable_dns_support     = bool
    enable_dns_hostnames   = bool
    enable_nat_gateway     = bool
    one_nat_gateway_per_az = bool
  })
  description = "VPC configuration object"
}