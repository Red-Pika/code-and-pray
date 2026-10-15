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
  default = "starter-network" }
resource "google_compute_network" "this" { name = var.name
  auto_create_subnetworks = false }
resource "google_compute_subnetwork" "private" {
  name = "${var.name}-private"
  ip_cidr_range = "10.50.1.0/24"
  region = var.region
  network = google_compute_network.this.id
  private_ip_google_access = true
}
output "network_id" { value = google_compute_network.this.id }
output "private_subnet_id" { value = google_compute_subnetwork.private.id }
