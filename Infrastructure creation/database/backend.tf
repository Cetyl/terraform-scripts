terraform {
  backend "s3" {
    bucket       = "prim-dev-p8-terraform"
    key          = "database/terraform.tfstate"
    region       = "us-east-1"
    # If you have a DynamoDB lock table, add: dynamodb_table = "terraform-locks"
  }
}
