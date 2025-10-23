####################
# Locals
####################

locals {
  ## Common tags
  common_tags = {
    Customer    = "rohan terraform"
    Cost-Center = "rohan terraform"
    Backup      = "false"
    Tier        = "NA"
    Environment = "DEV"
    Owner       = "rohan"
    Project     = "rohan_terraform"
  }


}