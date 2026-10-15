terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}
provider "aws" { region = var.aws_region }
variable "aws_region" {
  type = string
  default = "ap-southeast-1"
}
variable "name" {
  type = string
  default = "starter-edge"
}
resource "aws_vpc" "this" {
  cidr_block = "10.60.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = { Name = var.name }
}
data "aws_availability_zones" "available" { state = "available" }
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = { Name = "${var.name}-igw" }
}
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.this.id
  cidr_block = "10.60.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = { Name = "${var.name}-public" }
}
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.this.id
  cidr_block = "10.60.11.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false
  tags = { Name = "${var.name}-private" }
}
resource "aws_eip" "nat" { domain = "vpc" }
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public.id
  depends_on = [aws_internet_gateway.this]
  tags = { Name = "${var.name}-nat" }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = { Name = "${var.name}-public-rt" }
}
resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
  tags = { Name = "${var.name}-private-rt" }
}
resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
output "vpc_id" { value = aws_vpc.this.id }
output "public_subnet_id" { value = aws_subnet.public.id }
output "private_subnet_id" { value = aws_subnet.private.id }
output "nat_gateway_id" { value = aws_nat_gateway.this.id }
