####################
# VPC
####################
resource "aws_vpc" "vpc_01" {
  cidr_block           = var.vpc_01.cidr
  enable_dns_support   = var.vpc_01.enable_dns_support
  enable_dns_hostnames = var.vpc_01.enable_dns_hostnames

  tags = merge(local.common_tags_01, {
    Name = "${var.vpc_01.name}-vpc-${var.vpc_01.count}"
  })
}

####################
# Internet Gateway
####################
resource "aws_internet_gateway" "igw_01" {
  vpc_id = aws_vpc.vpc_01.id

  tags = merge(local.common_tags_01, {
    Name = "${var.vpc_01.name}-igw-${var.vpc_01.count}"
  })
} 

####################################################################################################
# Web Public Subnets
####################################################################################################
resource "aws_subnet" "pub_web_sub_01" {
  for_each = { for subnet in var.vpc_01.public_subnets : subnet.name => subnet }

  vpc_id                  = aws_vpc.vpc_01.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(local.common_tags_01, {
    Name = "${var.vpc_01.name}-${each.value.name}-${var.vpc_01.count}"
    Tier = "Web Public"
  })
}

####################
# Public Route Table (single RT)
####################
resource "aws_route_table" "pub_web_rt_01" {
  vpc_id = aws_vpc.vpc_01.id

  tags = merge(local.common_tags_01, {
    Name = "${var.vpc_01.name}-public-rt-${var.vpc_01.count}"
    Tier = "Web Public"
  })
}

resource "aws_route" "pub_web_default_rt_01" {
  route_table_id         = aws_route_table.pub_web_rt_01.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_01.id
}

resource "aws_route_table_association" "pub_web_sub_rt_assoc_01" {
  for_each = aws_subnet.pub_web_sub_01

  subnet_id      = each.value.id
  route_table_id = aws_route_table.pub_web_rt_01.id
}

####################
# Elastic IP for NAT Gateway
####################
resource "aws_eip" "eip_01" {
  count = var.vpc_01.enable_nat_gateway ? (var.vpc_01.one_nat_gateway_per_az ? length(var.vpc_01.public_subnets) : 1) : 0

  tags = merge(local.common_tags_01, {
    Name = var.vpc_01.one_nat_gateway_per_az ? "${var.vpc_01.name}-nat-eip-${var.vpc_01.public_subnets[count.index].az}-${var.vpc_01.count}" : "${var.vpc_01.name}-nat-eip-${var.vpc_01.count}"
  })
}

####################
# NAT Gateway
####################
resource "aws_nat_gateway" "natgw_01" {
  count = var.vpc_01.enable_nat_gateway ? (var.vpc_01.one_nat_gateway_per_az ? length(var.vpc_01.public_subnets) : 1) : 0

  allocation_id = aws_eip.eip_01[count.index].id
  subnet_id     = var.vpc_01.one_nat_gateway_per_az ? aws_subnet.pub_web_sub_01[keys(aws_subnet.pub_web_sub_01)[count.index]].id : values(aws_subnet.pub_web_sub_01)[0].id

  tags = merge(local.common_tags_01, {
    Name = var.vpc_01.one_nat_gateway_per_az ? "${var.vpc_01.name}-natgw-${var.vpc_01.public_subnets[count.index].az}-${var.vpc_01.count}" : "${var.vpc_01.name}-nat-gw-${var.vpc_01.count}"
  })
}

####################################################################################################
# Web Private Subnets
####################################################################################################
resource "aws_subnet" "pvt_web_sub_01" {
  for_each = { for subnet in var.vpc_01.private_web_subnets : subnet.name => subnet }

  vpc_id                  =aws_vpc.vpc_01.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = merge(local.common_tags_01, {
    Name = "${var.vpc_01.name}-${each.value.name}-${var.vpc_01.count}"
    Tier = "Web Private"
  })
}

####################
# Private Route Tables (one per private subnet)
####################
resource "aws_route_table" "pvt_web_rt_01" {
  for_each = { for subnet in var.vpc_01.private_web_subnets : subnet.name => subnet }

  vpc_id = aws_vpc.vpc_01.id

  tags = merge(local.common_tags_01, {
    Name = "${var.vpc_01.name}-${each.value.name}-rt-${var.vpc_01.count}"
    Tier = "Web Private"
  })
}

####################
# Associate private subnets with their RTs
####################
resource "aws_route_table_association" "pvt_web_sub_assoc_01" {
  for_each = aws_subnet.pvt_web_sub_01

  subnet_id      = each.value.id
  route_table_id = aws_route_table.pvt_web_rt_01[each.key].id
}

####################
# NAT routes for private RTs
####################
resource "aws_route" "pvt_web_natgw_route_01" {
  for_each = var.vpc_01.enable_nat_gateway ? aws_route_table.pvt_web_rt_01 : {}

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.vpc_01.one_nat_gateway_per_az ? aws_nat_gateway.natgw_01[index([for s in var.vpc_01.public_subnets : s.az], aws_subnet.pvt_web_sub_01[each.key].availability_zone)].id : aws_nat_gateway.natgw_01[0].id
}

####################################################################################################
# App Private Subnets
####################################################################################################
resource "aws_subnet" "pvt_app_sub_01" {
  for_each = { for subnet in var.vpc_01.private_app_subnets : subnet.name => subnet }

  vpc_id                  = aws_vpc.vpc_01.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = merge(local.common_tags_01, {
    Name = "${var.vpc_01.name}-${each.value.name}-${var.vpc_01.count}"
    Tier = "App Private"
  })
}

####################
# Private Route Tables (one per private subnet)
####################
resource "aws_route_table" "pvt_app_rt_01" {
  for_each = { for subnet in var.vpc_01.private_app_subnets : subnet.name => subnet }

  vpc_id = aws_vpc.vpc_01.id

  tags = merge(local.common_tags_01, {
    Name = "${var.vpc_01.name}-${each.value.name}-rt-${var.vpc_01.count}"
    Tier = "Private App"
  })
}

####################
# Associate private subnets with their RTs
####################
resource "aws_route_table_association" "pvt_app_sub_assoc_01" {
  for_each = aws_subnet.pvt_app_sub_01

  subnet_id      = each.value.id
  route_table_id = aws_route_table.pvt_app_rt_01[each.key].id
}

####################
# NAT routes for private RTs
####################
resource "aws_route" "pvt_app_natgw_route_01" {
  for_each = var.vpc_01.enable_nat_gateway ? aws_route_table.pvt_app_rt_01 : {}

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.vpc_01.one_nat_gateway_per_az ? aws_nat_gateway.natgw_01[index([for s in var.vpc_01.public_subnets : s.az], aws_subnet.pvt_app_sub_01[each.key].availability_zone)].id : aws_nat_gateway.natgw_01[0].id
}

####################################################################################################
# DB Private Subnets
####################################################################################################
resource "aws_subnet" "pvt_db_sub_01" {
  for_each = { for subnet in var.vpc_01.private_db_subnets : subnet.name => subnet }

  vpc_id                  = aws_vpc.vpc_01.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = merge(local.common_tags_01, {
    Name = "${var.vpc_01.name}-${each.value.name}-${var.vpc_01.count}"
    Tier = "DB Private"
  })
}

####################
# Private Route Tables (one per private subnet)
####################
resource "aws_route_table" "pvt_db_rt_01" {
  for_each = { for subnet in var.vpc_01.private_db_subnets : subnet.name => subnet }

  vpc_id = aws_vpc.vpc_01.id

  tags = merge(local.common_tags_01, {
    Name = "${var.vpc_01.name}-${each.value.name}-rt-${var.vpc_01.count}"
    Tier = "DB Private"
  })
}

####################
# Associate private subnets with their RTs
####################
resource "aws_route_table_association" "pvt_db_sub_assoc_01" {
  for_each = aws_subnet.pvt_db_sub_01

  subnet_id      = each.value.id
  route_table_id = aws_route_table.pvt_db_rt_01[each.key].id
}

####################
# NAT routes for private RTs
####################
resource "aws_route" "pvt_db_natgw_route_01" {
  for_each = var.vpc_01.enable_nat_gateway ? aws_route_table.pvt_db_rt_01 : {}

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.vpc_01.one_nat_gateway_per_az ? aws_nat_gateway.natgw_01[index(var.vpc_01.availability_zones, aws_subnet.pvt_db_sub_01[each.key].availability_zone)].id : aws_nat_gateway.natgw_01[0].id
}