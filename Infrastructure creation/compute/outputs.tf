####################
# EC2 01 Outputs
####################

output "ec2_01" {
  value = {
    instance_id       = aws_instance.ec2_01.id
    public_ip         = aws_instance.ec2_01.public_ip
    private_ip        = aws_instance.ec2_01.private_ip
    elastic_ip        = aws_eip.ec2_eip_01.public_ip
    security_group_id = aws_security_group.ec2_sg_01.id
  }
  description = "EC2 01 instance resources"
}

####################
# ALB 01 Outputs
####################

output "alb_01" {
  value = {
    alb_id = aws_lb.alb_01.id
    alb_arn = aws_lb.alb_01.arn
    alb_dns_name = aws_lb.alb_01.dns_name
    alb_zone_id = aws_lb.alb_01.zone_id
    security_group_id = aws_security_group.alb_sg_01.id
    alb_listener_01_arn = aws_lb_listener.alb_listener_01.arn
    listener_port = aws_lb_listener.alb_listener_01.port
  }
  description = "ALB 01 load balancer resources"
}

