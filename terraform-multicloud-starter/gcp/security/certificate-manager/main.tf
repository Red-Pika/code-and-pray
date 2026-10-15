terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = { source = "hashicorp/google", version = "~> 5.0" }
  }
}
provider "google" { project = var.project_id
  region = var.region
}
variable "project_id" { type = string }
variable "region" { type = string
  default = "asia-southeast2"
}
variable "domain_name" { type = string }
resource "google_certificate_manager_dns_authorization" "this" {
  name = "terraform-dns-auth"
  domain = var.domain_name
}
resource "google_certificate_manager_certificate" "this" {
  name = "terraform-managed-cert"
  managed {
    domains = [var.domain_name]
    dns_authorizations = [google_certificate_manager_dns_authorization.this.id]
  }
}
output "certificate_id" { value = google_certificate_manager_certificate.this.id }
