####################
# Essential VPC / Network outputs
####################

output "vpc_01" {
  value = {
    vpc_id = aws_vpc.vpc_01.id
    vpc_cidr = aws_vpc.vpc_01.cidr_block
    igw_id = aws_internet_gateway.igw_01.id
    public_subnet_ids = [for subnet in aws_subnet.pub_web_sub_01 : subnet.id]
    private_web_subnet_ids = [for subnet in aws_subnet.pvt_web_sub_01 : subnet.id]
    private_app_subnet_ids = [for subnet in aws_subnet.pvt_app_sub_01 : subnet.id]
    private_db_subnet_ids = [for subnet in aws_subnet.pvt_db_sub_01 : subnet.id]
  }
  description = "VPC 01 network resources"
}