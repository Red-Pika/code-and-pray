terraform {
  required_version = ">= 1.5.0"
  required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
}
provider "aws" { region = var.aws_region }
variable "aws_region" { type = string, default = "ap-southeast-1" }
variable "name" { type = string, default = "starter-network" }
resource "aws_vpc" "this" {
  cidr_block = "10.20.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = { Name = var.name }
}
resource "aws_subnet" "private_a" {
  vpc_id = aws_vpc.this.id
  cidr_block = "10.20.1.0/24"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = false
  tags = { Name = "${var.name}-private-a" }
}
output "vpc_id" { value = aws_vpc.this.id }
output "private_subnet_id" { value = aws_subnet.private_a.id }
