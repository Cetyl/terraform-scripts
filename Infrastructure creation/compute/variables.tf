variable "global_config" {
  description = "Global configuration settings"
  type = object({
    aws_region   = string
    aws_profile  = string
    environment  = string
    compute_prefix = string
  })
}

# Remote state configuration
variable "vpc_state_01" {
  description = "VPC remote state configuration"
  type = object({
    bucket = string
    key    = string
    region = string
  })
}

variable "storage_state_01" {
  description = "Storage remote state configuration"
  type = object({
    bucket = string
    key    = string
    region = string
  })
}

variable "security_state_01" {
  description = "Security remote state configuration"
  type = object({
    bucket = string
    key    = string
    region = string
  })
}

# EC2 Configuration
variable "ec2_config_01" {
  description = "EC2 01 complete configuration"
  type = object({
    count = string
    name  = string
    ami   = string
    instance_type = string
    
    # Security Group Rules
    security_group_rules = object({
      ingress = list(object({
        description = string
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
      }))
      egress = list(object({
        description = string
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
      }))
    })
  })
  default = {
    count = "01"
    name  = "prim-dev-p8-ec2"
    ami   = "ami-0c55b159cbfafe1f0"
    instance_type = "t3.micro"
    security_group_rules = {
      ingress = [
        {
          description = "SSH from anywhere"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          description = "HTTP from ALB"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/16"]
        }
      ]
      egress = [
        {
          description = "Allow all outbound traffic"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}

# ALB Configuration
variable "alb_config_01" {
  description = "ALB 01 complete configuration"
  type = object({
    count = string
    name  = string
    internal = bool
    load_balancer_type = string
    enable_cross_zone_load_balancing = bool
    idle_timeout = number
    domain_name = string
    auth0_domain = string
    auth0_client_id = string
    auth0_client_secret = string
    
    # Security Group Rules
    security_group_rules = object({
      ingress = list(object({
        description = string
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
      }))
      egress = list(object({
        description = string
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
      }))
    })
    
    tags = map(string)
  })
  default = {
    count = "01"
    name  = "prim-dev-p8-alb"
    internal = false
    load_balancer_type = "application"
    enable_cross_zone_load_balancing = true
    idle_timeout = 60
    domain_name = "example.com"
    auth0_domain = "https://example.auth0.com"
    auth0_client_id = ""
    auth0_client_secret = ""
    security_group_rules = {
      ingress = [
        {
          description = "HTTP from anywhere"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          description = "HTTPS from anywhere"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      egress = [
        {
          description = "Allow all outbound traffic"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
    tags = {}
  }
}

