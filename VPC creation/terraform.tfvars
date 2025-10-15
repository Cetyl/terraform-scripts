project_name = "prim-dev-p8"
environment  = "dev"

vpc_cidr = "10.0.8.0/21"

availability_zones = ["us-east-1a", "us-east-1b"]

web_public_subnets = [
  "10.0.8.0/25",
  "10.0.8.128/25"
]

web_private_subnets = [
  "10.0.9.0/25",
  "10.0.9.128/25"
]

app_private_subnets = [
  "10.0.10.0/23",
  "10.0.12.0/23"
]

database_subnets = [
  "10.0.14.0/26",
  "10.0.14.64/26"
]