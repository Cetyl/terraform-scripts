####################
# Locals
####################

locals {
  ## Common tags
  common_tags_01 = {
    Customer    = "rohan"
    Cost-Center = "rohan"
    Backup      = "NA"
    Tier        = "Database"
    Schedule    = "NA"
    Environment = "Dev"
    Owner       = "rohan"
    Project     = "infra"
  }
}