terraform {
  required_version = ">= 1.5.0"
  required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
}
provider "aws" { region = var.aws_region }
variable "aws_region" {
  type = string
  default = "ap-southeast-1"
  }
variable "name" {
  type = string
  default = "starter-web"
  }
resource "aws_vpc" "this" { cidr_block = "10.30.0.0/16" }
resource "aws_security_group" "web" {
  name = var.name
  description = "Allow HTTPS inbound no public SSH rule"
  vpc_id = aws_vpc.this.id
  ingress {
    description = "HTTPS"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = var.name }
}
output "security_group_id" { value = aws_security_group.web.id }
