resource "aws_key_pair" "terra-keypair" {
  key_name   = "terra-keypair"
  public_key = file("terra-key.pub")
}

resource "aws_instance" "caroline" {
  ami                    = var.AMIS["us-east-2"]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.tender-pub-1.id
  key_name               = aws_key_pair.terra-keypair.key_name
  vpc_security_group_ids = [aws_security_group.tender-sg.id]
  tags = {
    Name = var.TAGS
  }
}

resource "aws_ebs_volume" "part-of-band" {
  availability_zone = "us-east-1a"
  size              = 3

  tags = {
    Name = "vol-for-tender"
  }
}

resource "aws_volume_attachment" "ebs_att-vol" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.part-of-band.id
  instance_id = aws_instance.caroline.id
}


output "public_ip" {
  value = aws_instance.caroline.public_ip
}

output "private_ip" {
  value = aws_instance.caroline.private_ip
}