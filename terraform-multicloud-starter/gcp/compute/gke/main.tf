terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = { source = "hashicorp/google", version = "~> 5.0" }
  }
}
provider "google" {
  project = var.project_id
  region = var.region
}
variable "project_id" {
  type = string
  description = "GCP project ID"
}
variable "region" {
  type = string
  default = "asia-southeast2"
}
variable "cluster_name" {
  type = string
  default = "starter-gke"
}
variable "network" {
  type = string
  description = "VPC self-link"
}
variable "subnetwork" {
  type = string
  description = "Subnet self-link"
}
resource "google_container_cluster" "this" {
  name = var.cluster_name
  location = var.region
  network = var.network
  subnetwork = var.subnetwork
  deletion_protection = true
  remove_default_node_pool = true
  initial_node_count = 1
  release_channel { channel = "REGULAR" }
  ip_allocation_policy {}
  private_cluster_config {
    enable_private_nodes = true
    enable_private_endpoint = false
    master_ipv4_cidr_block = "172.16.0.0/28"
  }
}
resource "google_container_node_pool" "primary" {
  name = "primary"
  location = var.region
  cluster = google_container_cluster.this.name
  node_count = 2
  node_config {
    machine_type = "e2-standard-2"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
output "cluster_name" { value = google_container_cluster.this.name }
output "cluster_endpoint" { value = google_container_cluster.this.endpoint }
