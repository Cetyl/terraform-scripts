terraform {
  backend "s3" {
    bucket         = "terr-s3-test"                    # Specify the name of your S3 bucket
    key            = "cetyl/terraform.tfstate"         # Path to the state file within the bucket
    region         = "us-east-1"                       # AWS region where the bucket is located
    encrypt        = true                              # Enable encryption for the state file
    #dynamodb_table = "terraform-lock"                  # Name of the DynamoDB table for state locking
  }
}
