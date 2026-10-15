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
variable "domain_name" { type = string }
variable "subject_alternative_names" { type = list(string)
  default = []
}
variable "route53_zone_id" { type = string
  description = "Hosted zone ID for DNS validation"
}
resource "aws_acm_certificate" "this" {
  domain_name = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method = "DNS"
  lifecycle { create_before_destroy = true }
}
resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }
  zone_id = var.route53_zone_id
  name = each.value.name
  type = each.value.type
  records = [each.value.record]
  ttl = 60
  allow_overwrite = true
}
resource "aws_acm_certificate_validation" "this" {
  certificate_arn = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
output "certificate_arn" { value = aws_acm_certificate_validation.this.certificate_arn }
