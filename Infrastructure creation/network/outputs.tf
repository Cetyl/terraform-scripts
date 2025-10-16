####################
# Essential VPC / Network outputs
####################

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the VPC"
}

output "vpc_cidr" {
  value       = aws_vpc.main.cidr_block
  description = "CIDR block of the VPC"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.main.id
  description = "Internet Gateway ID attached to the VPC"
}

output "public_route_table_id" {
  value       = aws_route_table.public.id
  description = "Public route table ID used by public subnets"
}

output "public_subnet_ids" {
  value       = [for subnet in aws_subnet.public : subnet.id]
  description = "List of public subnet IDs"
}

output "public_subnets" {
  value = {
    for k, v in aws_subnet.public : k => {
      id   = v.id
      cidr = v.cidr_block
      az   = v.availability_zone
      name = v.tags.Name
    }
  }
  description = "Map of public subnets with their details"
}

output "private_subnet_ids" {
  value       = [for subnet in aws_subnet.private : subnet.id]
  description = "List of private subnet IDs"
}

output "private_subnets" {
  value = {
    for k, v in aws_subnet.private : k => {
      id   = v.id
      cidr = v.cidr_block
      az   = v.availability_zone
      name = v.tags.Name
    }
  }
  description = "Map of private subnets with their details"
}

output "private_route_table_ids" {
  value       = [for rt in aws_route_table.private : rt.id]
  description = "List of private route table IDs"
}

output "nat_gateway_ids" {
  value       = var.enable_nat_gateway ? [for nat in aws_nat_gateway.main : nat.id] : []
  description = "List of NAT Gateway IDs used by private subnets"
}

output "nat_gateway_id" {
  value       = var.enable_nat_gateway ? aws_nat_gateway.main[0].id : null
  description = "Primary NAT Gateway ID (for backward compatibility)"
}

output "nat_eip_public_ips" {
  value       = var.enable_nat_gateway ? [for eip in aws_eip.nat : eip.public_ip] : []
  description = "List of public IPs of the EIPs allocated for the NAT Gateways"
}

output "nat_eip_public_ip" {
  value       = var.enable_nat_gateway ? aws_eip.nat[0].public_ip : null
  description = "Primary NAT Gateway EIP public IP (for backward compatibility)"
}

output "availability_zones" {
  value       = var.availability_zones
  description = "List of availability zones used"
}