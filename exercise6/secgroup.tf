resource "aws_security_group" "tender-sg" {
  vpc_id      = aws_vpc.tender.id
  name        = "tender-sg"
  description = "sec group for tender ssh"

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["103.76.59.59/32"]
    from_port   = 22
    to_port     = 22
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-ssh"
  }

}
