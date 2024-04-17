resource "aws_vpc" "tender" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "tender"
  }
}

resource "aws_subnet" "tender-pub-1" {
  vpc_id                  = aws_vpc.tender.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "tender-pub-1"
  }
}

resource "aws_subnet" "tender-pub-2" {
  vpc_id                  = aws_vpc.tender.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "tender-pub-2"
  }
}

resource "aws_subnet" "tender-pub-3" {
  vpc_id                  = aws_vpc.tender.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1c"

  tags = {
    Name = "tender-pub-3"
  }
}

resource "aws_subnet" "tender-pvt-1" {
  vpc_id                  = aws_vpc.tender.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "tender-pvt-1"
  }
}

resource "aws_subnet" "tender-pvt-2" {
  vpc_id                  = aws_vpc.tender.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "tender-pvt-2"
  }
}


resource "aws_subnet" "tender-pvt-3" {
  vpc_id                  = aws_vpc.tender.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1c"

  tags = {
    Name = "tender-pvt-3"
  }
}

resource "aws_internet_gateway" "tender-IGW" {
  vpc_id = aws_vpc.tender.id

  tags = {
    Name = "tender-IGW"
  }
}

resource "aws_route_table" "tender-pub-rt" {
  vpc_id = aws_vpc.tender.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tender-IGW.id
  }
  tags = {
    Name = "tender-pub-rt"
  }
}

resource "aws_route_table_association" "tender-pub-1-a" {
  subnet_id      = aws_subnet.tender-pub-1.id
  route_table_id = aws_route_table.tender-pub-rt.id
}

resource "aws_route_table_association" "tender-pub-2-a" {
  subnet_id      = aws_subnet.tender-pub-2.id
  route_table_id = aws_route_table.tender-pub-rt.id
}

resource "aws_route_table_association" "tender-pub-3-a" {
  subnet_id      = aws_subnet.tender-pub-3.id
  route_table_id = aws_route_table.tender-pub-rt.id
}