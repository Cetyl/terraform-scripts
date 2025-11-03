output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.web_public[*].id
}

output "private_web_subnets" {
  value = aws_subnet.web_private[*].id
}

output "private_app_subnets" {
  value = aws_subnet.app_private[*].id
}

output "database_subnets" {
  # Corresponds to resource "aws_subnet" "database" in main.tf
  value = aws_subnet.database[*].id
}

output "nat_gateways" {
  # Corresponds to resource "aws_nat_gateway" "main" in main.tf
  value = aws_nat_gateway.main[*].id
}

output "internet_gateway" {
  value = aws_internet_gateway.main.id
}
