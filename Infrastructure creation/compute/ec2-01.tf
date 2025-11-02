####################
# Security Group for EC2 01
####################
resource "aws_security_group" "ec2_sg_01" {
  name        = "${var.ec2_config_01.name}-sg-${var.ec2_config_01.count}"
  description = "Security group for EC2"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_01.vpc_id

  tags = merge(local.common_tags_01, {
    Name = "${var.ec2_config_01.name}-sg-${var.ec2_config_01.count}"
  })
}

resource "aws_security_group_rule" "ec2_ingress_rules_01" {
  count = length(var.ec2_config_01.security_group_rules.ingress)
  type              = "ingress"
  from_port         = var.ec2_config_01.security_group_rules.ingress[count.index].from_port
  to_port           = var.ec2_config_01.security_group_rules.ingress[count.index].to_port
  protocol          = var.ec2_config_01.security_group_rules.ingress[count.index].protocol
  cidr_blocks       = var.ec2_config_01.security_group_rules.ingress[count.index].cidr_blocks
  description       = var.ec2_config_01.security_group_rules.ingress[count.index].description
  security_group_id = aws_security_group.ec2_sg_01.id
}

resource "aws_security_group_rule" "ec2_egress_rules_01" {
  count = length(var.ec2_config_01.security_group_rules.egress)
  type              = "egress"
  from_port         = var.ec2_config_01.security_group_rules.egress[count.index].from_port
  to_port           = var.ec2_config_01.security_group_rules.egress[count.index].to_port
  protocol          = var.ec2_config_01.security_group_rules.egress[count.index].protocol
  cidr_blocks       = var.ec2_config_01.security_group_rules.egress[count.index].cidr_blocks
  description       = var.ec2_config_01.security_group_rules.egress[count.index].description
  security_group_id = aws_security_group.ec2_sg_01.id
}

####################
# EC2 Instance 01
####################
resource "aws_instance" "ec2_01" {
  ami           = var.ec2_config_01.ami
  instance_type = var.ec2_config_01.instance_type
  subnet_id     = data.terraform_remote_state.network.outputs.vpc_01.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg_01.id]

  user_data = <<-EOF
              #!/bin/bash
              yum install -y nginx
              systemctl start nginx
              echo "<h1>Authenticated via Auth0!</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = merge(local.common_tags_01, {
    Name = "${var.ec2_config_01.name}-${var.ec2_config_01.count}"
  })
}
