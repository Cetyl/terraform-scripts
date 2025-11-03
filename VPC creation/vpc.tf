# -----------------------------------------------------------------
# 1. VPC
# -----------------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    # Output: prim-dev-p8-vpc
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
  }
}

# -----------------------------------------------------------------
# 2. Internet Gateway (IGW)
# -----------------------------------------------------------------
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    # Output: prim-dev-p8-igw
    Name        = "${var.project_name}-igw"
    Environment = var.environment
  }
}

# -----------------------------------------------------------------
# 3. Subnets (Web Public, Web Private, App Private, Database)
# -----------------------------------------------------------------

# Public Subnets (e.g., prim-dev-p8-web-pub-snt-1a)
resource "aws_subnet" "web_public" {
  count                   = length(var.web_public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.web_public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-web-pub-snt-${replace(var.availability_zones[count.index], "us-east-", "")}"
    Environment = var.environment
  }
}

# Private Subnets - Web Tier (e.g., prim-dev-p8-web-private-snt-1a)
resource "aws_subnet" "web_private" {
  count             = length(var.web_private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.web_private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.project_name}-web-private-snt-${replace(var.availability_zones[count.index], "us-east-", "")}"
    Environment = var.environment
  }
}

# Private Subnets - App Tier (e.g., prim-dev-p8-app-private-snt-1a)
resource "aws_subnet" "app_private" {
  count             = length(var.app_private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.project_name}-app-private-snt-${replace(var.availability_zones[count.index], "us-east-", "")}"
    Environment = var.environment
  }
}

# Private Subnets - DB Tier (e.g., prim-dev-p8-db-private-snt-1a)
resource "aws_subnet" "database" {
  count             = length(var.database_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.project_name}-db-private-snt-${replace(var.availability_zones[count.index], "us-east-", "")}"
    Environment = var.environment
  }
}

# -----------------------------------------------------------------
# 4. NAT Gateway + EIP (Configured for Single NAT)
# -----------------------------------------------------------------

# Single EIP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-nat-eip"
    Environment = var.environment
  }
}

# Single NAT Gateway placed in the first public subnet (us-east-1a)
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.web_public[0].id # Use the first public subnet

  tags = {
    # Output: prim-dev-p8-natgw
    Name        = "${var.project_name}-natgw"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.main]
}

# -----------------------------------------------------------------
# 5. Route Tables (Prefix "RTB-" has been removed)
# -----------------------------------------------------------------

# Public Route Table (prim-dev-p8-web-pub)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    # Output: prim-dev-p8-web-pub (Removed RTB-)
    Name        = "${var.project_name}-web-pub"
    Environment = var.environment
  }
}

# Private RTs - Web Tier (e.g., prim-dev-p8-web-private-1a)
resource "aws_route_table" "web_private" {
  count  = length(var.web_private_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    # All private tiers point to the single NAT Gateway
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    # Output: prim-dev-p8-web-private-1a (Removed RTB-)
    Name        = "${var.project_name}-web-private-${replace(var.availability_zones[count.index], "us-east-", "")}"
    Environment = var.environment
  }
}

# Private RTs - App Tier (e.g., prim-dev-p8-app-private-1a)
resource "aws_route_table" "app_private" {
  count  = length(var.app_private_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    # All private tiers point to the single NAT Gateway
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    # Output: prim-dev-p8-app-private-1a (Removed RTB-)
    Name        = "${var.project_name}-app-private-${replace(var.availability_zones[count.index], "us-east-", "")}"
    Environment = var.environment
  }
}

# Private RTs - DB Tier (e.g., prim-dev-p8-db-private-1a)
resource "aws_route_table" "database" {
  count  = length(var.database_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    # All private tiers point to the single NAT Gateway
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    # Output: prim-dev-p8-db-private-1a (Removed RTB-)
    Name        = "${var.project_name}-db-private-${replace(var.availability_zones[count.index], "us-east-", "")}"
    Environment = var.environment
  }
}

# -----------------------------------------------------------------
# 6. Route Table Associations
# -----------------------------------------------------------------

# Association: All Public Subnets -> Public RTB
resource "aws_route_table_association" "web_public" {
  count          = length(var.web_public_subnets)
  subnet_id      = aws_subnet.web_public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Association: Web Private Subnets -> Web Private RTBs
resource "aws_route_table_association" "web_private" {
  count          = length(var.web_private_subnets)
  subnet_id      = aws_subnet.web_private[count.index].id
  route_table_id = aws_route_table.web_private[count.index].id
}

# Association: App Private Subnets -> App Private RTBs
resource "aws_route_table_association" "app_private" {
  count          = length(var.app_private_subnets)
  subnet_id      = aws_subnet.app_private[count.index].id
  route_table_id = aws_route_table.app_private[count.index].id
}

# Association: DB Private Subnets -> DB Private RTBs
resource "aws_route_table_association" "database" {
  count          = length(var.database_subnets)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database[count.index].id
}
