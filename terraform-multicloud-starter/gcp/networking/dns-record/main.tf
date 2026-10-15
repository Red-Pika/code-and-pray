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
variable "dns_name" { type = string
  description = "DNS zone name, e.g. example-com"
}
variable "dns_suffix" { type = string
  description = "DNS suffix with trailing dot, e.g. example.com."
}
variable "record_name" { type = string }
variable "ipv4_address" { type = string }
resource "google_dns_managed_zone" "this" {
  name = var.dns_name
  dns_name = var.dns_suffix
  visibility = "public"
}
resource "google_dns_record_set" "this" {
  name = "${var.record_name}.${var.dns_suffix}"
  managed_zone = google_dns_managed_zone.this.name
  type = "A"
  ttl = 300
  rrdatas = [var.ipv4_address]
}
output "record_name" { value = google_dns_record_set.this.name }
