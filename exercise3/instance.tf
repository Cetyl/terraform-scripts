resource "aws_key_pair" "terra-keypair" {
  key_name   = "terra-keypair"
  public_key = file("terra-key.pub")
}

resource "aws_instance" "provisioners" {
  ami                    = var.AMIS["us-east-2"]
  instance_type          = "t2.micro"
  availability_zone      = var.ZONE
  key_name               = aws_key_pair.terra-keypair.key_name
  vpc_security_group_ids = ["sg-03537ec9953435ac6"]
  tags = {
    Name = var.TAGS
  }

  provisioner "file" {
    source      = "shell1.sh"
    destination = "/tmp/shell1.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/shell1.sh",
      "sudo /tmp/shell1.sh"
    ]
  }

  connection {
    user        = "ec2-user"
    private_key = file("terra-key")
    host        = self.public_ip
  }

}