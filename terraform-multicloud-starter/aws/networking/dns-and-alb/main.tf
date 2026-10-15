terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}
provider "aws" { region = var.aws_region }
variable "aws_region" { type = string
  default = "ap-southeast-1"
}
variable "name" { type = string
  default = "starter-alb"
}
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "certificate_arn" { type = string
  description = "ACM certificate ARN in the same region"
}
variable "target_instance_ids" { type = list(string)
  default = []
}
resource "aws_lb" "this" {
  name = var.name
  internal = false
  load_balancer_type = "application"
  security_groups = []
  subnets = var.public_subnet_ids
  enable_deletion_protection = true
}
resource "aws_lb_target_group" "this" {
  name = "${var.name}-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "instance"
  health_check {
    path = "/"
    matcher = "200-399"
  }
}
resource "aws_lb_target_group_attachment" "this" {
  count = length(var.target_instance_ids)
  target_group_arn = aws_lb_target_group.this.arn
  target_id = var.target_instance_ids[count.index]
  port = 80
}
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port = 443
  protocol = "HTTPS"
  certificate_arn = var.certificate_arn
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
output "load_balancer_dns_name" { value = aws_lb.this.dns_name }
