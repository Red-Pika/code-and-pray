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
variable "vpc_id" { type = string }
variable "customer_gateway_public_ip" { type = string }
variable "customer_gateway_bgp_asn" { type = number
  default = 65000
}
variable "static_routes_only" { type = bool
  default = true
}
resource "aws_vpn_gateway" "this" {
  vpc_id = var.vpc_id
  tags = { Name = "terraform-site-to-site-vpn" }
}
resource "aws_customer_gateway" "this" {
  bgp_asn = var.customer_gateway_bgp_asn
  ip_address = var.customer_gateway_public_ip
  type = "ipsec.1"
  tags = { Name = "terraform-customer-gateway" }
}
resource "aws_vpn_connection" "this" {
  vpn_gateway_id = aws_vpn_gateway.this.id
  customer_gateway_id = aws_customer_gateway.this.id
  type = "ipsec.1"
  static_routes_only = var.static_routes_only
  tags = { Name = "terraform-site-to-site-vpn" }
}
output "vpn_connection_id" { value = aws_vpn_connection.this.id }
output "vpn_gateway_id" { value = aws_vpn_gateway.this.id }
