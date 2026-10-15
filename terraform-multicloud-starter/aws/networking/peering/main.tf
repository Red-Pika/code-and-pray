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
variable "requester_vpc_id" { type = string }
variable "accepter_vpc_id" { type = string }
variable "accepter_owner_id" {
  type = string
  default = null
}
variable "auto_accept" {
  type = bool
  default = false
}
resource "aws_vpc_peering_connection" "this" {
  vpc_id = var.requester_vpc_id
  peer_vpc_id = var.accepter_vpc_id
  peer_owner_id = var.accepter_owner_id
  auto_accept = var.auto_accept
  tags = { Name = "terraform-vpc-peering" }
}
output "peering_connection_id" { value = aws_vpc_peering_connection.this.id }
