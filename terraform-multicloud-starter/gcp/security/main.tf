terraform {
  required_version = ">= 1.5.0"
  required_providers { google = { source = "hashicorp/google", version = "~> 5.0" } }
}
provider "google" { project = var.project_id
  region = var.region }
variable "project_id" { type = string
  description = "GCP project ID" }
variable "region" { type = string
  default = "asia-southeast2" }
variable "name" { type = string
  default = "starter-allow-https" }
resource "google_compute_network" "this" { name = "${var.name}-vpc"
  auto_create_subnetworks = false }
resource "google_compute_firewall" "https" {
  name = var.name
  network = google_compute_network.this.name
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["https-server"]
  allow { protocol = "tcp"
  ports = ["443"] }
}
output "firewall_rule_name" { value = google_compute_firewall.https.name }
