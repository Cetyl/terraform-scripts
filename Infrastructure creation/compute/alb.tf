####################
# Security Group for ALB 01
####################
resource "aws_security_group" "alb_sg_01" {
  name        = "${var.alb_config_01.name}-sg-${var.alb_config_01.count}"
  description = "Security group for ALB"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_01.vpc_id

  tags = merge(local.common_tags_01, {
    Name = "${var.alb_config_01.name}-sg-${var.alb_config_01.count}"
  })
}

resource "aws_security_group_rule" "alb_ingress_rules_01" {
  count = length(var.alb_config_01.security_group_rules.ingress)

  type              = "ingress"
  from_port         = var.alb_config_01.security_group_rules.ingress[count.index].from_port
  to_port           = var.alb_config_01.security_group_rules.ingress[count.index].to_port
  protocol          = var.alb_config_01.security_group_rules.ingress[count.index].protocol
  cidr_blocks       = var.alb_config_01.security_group_rules.ingress[count.index].cidr_blocks
  description       = var.alb_config_01.security_group_rules.ingress[count.index].description
  security_group_id = aws_security_group.alb_sg_01.id
}

resource "aws_security_group_rule" "alb_egress_rules_01" {
  count = length(var.alb_config_01.security_group_rules.egress)

  type              = "egress"
  from_port         = var.alb_config_01.security_group_rules.egress[count.index].from_port
  to_port           = var.alb_config_01.security_group_rules.egress[count.index].to_port
  protocol          = var.alb_config_01.security_group_rules.egress[count.index].protocol
  cidr_blocks       = var.alb_config_01.security_group_rules.egress[count.index].cidr_blocks
  description       = var.alb_config_01.security_group_rules.egress[count.index].description
  security_group_id = aws_security_group.alb_sg_01.id
}

####################
# Application Load Balancer 01
####################
resource "aws_lb" "alb_01" {
  name               = "${var.alb_config_01.name}-${var.alb_config_01.count}"
  internal           = var.alb_config_01.internal
  load_balancer_type = var.alb_config_01.load_balancer_type
  security_groups    = [aws_security_group.alb_sg_01.id]
  subnets            = data.terraform_remote_state.network.outputs.vpc_01.public_subnet_ids

  enable_cross_zone_load_balancing = var.alb_config_01.enable_cross_zone_load_balancing
  idle_timeout                     = var.alb_config_01.idle_timeout

  access_logs {
    bucket  = data.terraform_remote_state.storage.outputs.storage_03.bucket_name
    enabled = true
    prefix  = "alb-access-logs"
  }

  depends_on = [aws_security_group.alb_sg_01]

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.common_tags_01, var.alb_config_01.tags)
}

####################
# ALB Target Group 01
####################
resource "aws_lb_target_group" "alb_tg_01" {
  name     = "${var.alb_config_01.name}-tg-${var.alb_config_01.count}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.network.outputs.vpc_01.vpc_id

  health_check {
    path                = "/"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = merge(local.common_tags_01, {
    Name = "${var.alb_config_01.name}-tg-${var.alb_config_01.count}"
  })
}

####################
# ALB Target Attachment (EC2 from compute)
####################
resource "aws_lb_target_group_attachment" "alb_tg_attach_01" {
  target_group_arn = aws_lb_target_group.alb_tg_01.arn
  target_id        = data.terraform_remote_state.compute.outputs.ec2_01.id
  port             = 80
}

####################
# ACM Certificate for OIDC Subdomain
####################
resource "aws_acm_certificate" "alb_cert_01" {
  domain_name       = var.alb_config_01.domain_name
  validation_method = "DNS"

  tags = merge(local.common_tags_01, {
    Name = "${var.alb_config_01.name}-cert-${var.alb_config_01.count}"
  })
}

####################
# ALB Listener 01 (HTTP → HTTPS Redirect)
####################
resource "aws_lb_listener" "alb_listener_http_01" {
  load_balancer_arn = aws_lb.alb_01.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = merge(local.common_tags_01, {
    Name = "${var.alb_config_01.name}-listener-http-${var.alb_config_01.count}"
  })
}

####################
# ALB Listener 02 (HTTPS + Auth0 OIDC)
####################
resource "aws_lb_listener" "alb_listener_https_01" {
  load_balancer_arn = aws_lb.alb_01.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.alb_cert_01.arn

  default_action {
    type = "authenticate-oidc"
    authenticate_oidc {
      authorization_endpoint    = "${var.alb_config_01.auth0_domain}/authorize"
      token_endpoint            = "${var.alb_config_01.auth0_domain}/oauth/token"
      user_info_endpoint        = "${var.alb_config_01.auth0_domain}/userinfo"
      client_id                 = var.alb_config_01.auth0_client_id
      client_secret             = var.alb_config_01.auth0_client_secret
      issuer                    = var.alb_config_01.auth0_domain
      session_cookie_name       = "alb-auth0-session"
      session_timeout           = 3600
      scope                     = "openid profile email"
      on_unauthenticated_request = "authenticate"
    }
    order = 1
  }

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_01.arn
    order            = 2
  }

  tags = merge(local.common_tags_01, {
    Name = "${var.alb_config_01.name}-listener-https-${var.alb_config_01.count}"
  })
}

####################
# Outputs
####################
output "alb_dns_name_01" {
  value = aws_lb.alb_01.dns_name
}

