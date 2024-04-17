resource "aws_instance" "vars-test" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = "t2.micro"
  availability_zone      = var.ZONE1
  key_name               = "kuber"
  vpc_security_group_ids = ["sg-03537ec9953435ac6"]
  tags = {
    Name = "vars-terra-test"
  }


}