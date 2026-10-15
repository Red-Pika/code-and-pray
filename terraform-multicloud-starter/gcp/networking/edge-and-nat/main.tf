terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = { source = "hashicorp/google", version = "~> 5.0" }
  }
}
provider "google" { project = var.project_id
  region = var.region
}
variable "project_id" { type = string
  description = "GCP project ID"
}
variable "region" { type = string
  default = "asia-southeast2"
}
variable "name" { type = string
  default = "starter-edge"
}
resource "google_compute_network" "this" {
  name = var.name
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "public" {
  name = "${var.name}-public"
  ip_cidr_range = "10.80.1.0/24"
  region = var.region
  network = google_compute_network.this.id
}
resource "google_compute_subnetwork" "private" {
  name = "${var.name}-private"
  ip_cidr_range = "10.80.11.0/24"
  region = var.region
  network = google_compute_network.this.id
  private_ip_google_access = true
}
resource "google_compute_router" "this" {
  name = "${var.name}-router"
  region = var.region
  network = google_compute_network.this.id
  bgp { asn = 64514 }
}
resource "google_compute_router_nat" "this" {
  name = "${var.name}-nat"
  router = google_compute_router.this.name
  region = var.region
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
resource "google_compute_firewall" "https" {
  name = "${var.name}-allow-https"
  network = google_compute_network.this.name
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["https-server"]
  allow { protocol = "tcp"
    ports = ["443"]
  }
}
output "network_id" { value = google_compute_network.this.id }
output "private_subnet_id" { value = google_compute_subnetwork.private.id }
output "cloud_nat_name" { value = google_compute_router_nat.this.name }
