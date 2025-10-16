####################
# Locals
####################

locals {
  ## Common tags
  common_tags = {
    Customer    = "primo-brands"
    Cost-Center = "primo-brands"
    Backup      = "false"
    Tier        = ""
    Schedule    = ""
    Environment = var.environment
    Owner       = "dcai 360"
    Project     = var.project_name
  }

  ## Name prefix for resources
  name_prefix = "${var.project_name}-${var.environment}"
}