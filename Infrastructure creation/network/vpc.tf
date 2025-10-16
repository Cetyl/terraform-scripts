####################
# VPC
####################
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-vpc"
  })
}

####################
# Internet Gateway
####################
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-igw"
  })
}

####################
# Public Subnets
####################
resource "aws_subnet" "public" {
  for_each = { for subnet in var.public_subnets : subnet.name => subnet }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${each.value.name}"
    Type = "public"
  })
}

####################
# Public Route Table (single RT)
####################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-public-rt"
  })
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

####################
# Elastic IP for NAT Gateway
####################
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? (var.one_nat_gateway_per_az ? length(var.availability_zones) : 1) : 0

  tags = merge(local.common_tags, {
    Name = var.one_nat_gateway_per_az ? "${var.project_name}-nat-eip-${var.availability_zones[count.index]}" : "${var.project_name}-nat-eip"
  })
}

####################
# NAT Gateway
####################
resource "aws_nat_gateway" "main" {
  count = var.enable_nat_gateway ? (var.one_nat_gateway_per_az ? length(var.availability_zones) : 1) : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = var.one_nat_gateway_per_az ? aws_subnet.public[keys(aws_subnet.public)[count.index]].id : values(aws_subnet.public)[0].id

  tags = merge(local.common_tags, {
    Name = var.one_nat_gateway_per_az ? "${var.project_name}-natgw-${var.availability_zones[count.index]}" : "${var.project_name}-nat-gw"
  })
}

####################
# Private Subnets
####################
resource "aws_subnet" "private" {
  for_each = { for subnet in var.private_subnets : subnet.name => subnet }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${each.value.name}"
    Type = "private"
  })
}

####################
# Private Route Tables (one per private subnet)
####################
resource "aws_route_table" "private" {
  for_each = aws_subnet.private

  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${each.value.tags.Name}-rt"
  })
}

####################
# Associate private subnets with their RTs
####################
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

####################
# NAT routes for private RTs
####################
resource "aws_route" "private_nat" {
  for_each = var.enable_nat_gateway ? aws_route_table.private : {}

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.one_nat_gateway_per_az ? aws_nat_gateway.main[index(var.availability_zones, aws_subnet.private[each.key].availability_zone)].id : aws_nat_gateway.main[0].id
}