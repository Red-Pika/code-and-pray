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
variable "zone_id" { type = string }
variable "record_name" { type = string }
variable "target_dns_name" { type = string }
variable "target_zone_id" { type = string }
resource "aws_route53_record" "this" {
  zone_id = var.zone_id
  name = var.record_name
  type = "A"
  alias {
    name = var.target_dns_name
    zone_id = var.target_zone_id
    evaluate_target_health = true
  }
}
output "record_fqdn" { value = aws_route53_record.this.fqdn }
