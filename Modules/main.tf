provider "aws" {
    region = "us-east-1"
  }

module "ec2_instance" {
    source = "./ec_instance"
    ami_value = "ami-0e86e20dae9224db8"
    instance_type_value = "t2.micro"
    region_value = "us-east-1"

}  
