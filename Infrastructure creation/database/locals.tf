####################
# Locals
####################

locals {
  ## Common tags
  common_tags_01 = {
    Customer    = "Primo Brands"
    Cost-Center = "Primo Brands"
    Backup      = "NA"
    Tier        = "Database"
    Schedule    = "NA"
    Environment = "Dev"
    Owner       = "rohan"
    Project     = "infra"
  }
}