# ------------------------------
# VPC
# ------------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
  }
}

# ------------------------------
# Internet Gateway
# ------------------------------
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-igw"
    Environment = var.environment
  }
}

# ------------------------------
# Public Subnets
# ------------------------------
resource "aws_subnet" "web_public" {
  count                   = length(var.web_public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.web_public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-web-public-${count.index + 1}"
    Environment = var.environment
  }
}

# ------------------------------
# Private Subnets - Web / App / DB
# ------------------------------
resource "aws_subnet" "web_private" {
  count             = length(var.web_private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.web_private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.project_name}-web-private-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_subnet" "app_private" {
  count             = length(var.app_private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.project_name}-app-private-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_subnet" "database" {
  count             = length(var.database_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.project_name}-database-${count.index + 1}"
    Environment = var.environment
  }
}

# ------------------------------
# NAT Gateway + EIP
# ------------------------------
resource "aws_eip" "nat" {
  count  = length(var.web_public_subnets)
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-nat-eip-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "main" {
  count         = length(var.web_public_subnets)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.web_public[count.index].id

  tags = {
    Name        = "${var.project_name}-nat-${count.index + 1}"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.main]
}

# ------------------------------
# Route Tables
# ------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.project_name}-public-rt"
    Environment = var.environment
  }
}

# Private RTs (Web/App/DB)
resource "aws_route_table" "web_private" {
  count  = length(var.web_private_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    Name        = "${var.project_name}-web-private-rt-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_route_table" "app_private" {
  count  = length(var.app_private_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    Name        = "${var.project_name}-app-private-rt-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_route_table" "database" {
  count  = length(var.database_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    Name        = "${var.project_name}-database-rt-${count.index + 1}"
    Environment = var.environment
  }
}

# ------------------------------
# Route Table Associations
# ------------------------------
resource "aws_route_table_association" "web_public" {
  count          = length(var.web_public_subnets)
  subnet_id      = aws_subnet.web_public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "web_private" {
  count          = length(var.web_private_subnets)
  subnet_id      = aws_subnet.web_private[count.index].id
  route_table_id = aws_route_table.web_private[count.index].id
}

resource "aws_route_table_association" "app_private" {
  count          = length(var.app_private_subnets)
  subnet_id      = aws_subnet.app_private[count.index].id
  route_table_id = aws_route_table.app_private[count.index].id
}

resource "aws_route_table_association" "database" {
  count          = length(var.database_subnets)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database[count.index].id
}
