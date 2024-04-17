variable "REGION" {
  default = "us-east-1"
}

variable "ZONE" {
  default = "us-east-1a"
}

variable "AMIS" {
  type = map(any)
  default = {
    us-east-1 = "ami-080e1f13689e07408"
    us-east-2 = "ami-051f8a213df8bc089"
  }
}

variable "TAGS" {
  default = "prov-test"
}

