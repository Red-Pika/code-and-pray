terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = { source = "hashicorp/google", version = "~> 5.0" }
    random = { source = "hashicorp/random", version = "~> 3.6" }
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
variable "name" {
  type = string
  default = "starter-ha-vpn"
}
variable "network_self_link" { type = string }
variable "peer_gateway_ip_0" { type = string }
variable "peer_gateway_ip_1" { type = string }
variable "peer_bgp_asn" {
  type = number
  default = 65000
}
resource "google_compute_ha_vpn_gateway" "this" {
  name = var.name
  region = var.region
  network = var.network_self_link
}
resource "google_compute_router" "this" {
  name = "${var.name}-router"
  region = var.region
  network = var.network_self_link
  bgp { asn = 64514 }
}
resource "google_compute_external_vpn_gateway" "peer" {
  name = "${var.name}-peer"
  redundancy_type = "TWO_IPS_REDUNDANCY"
  interface {
    id = 0
    ip_address = var.peer_gateway_ip_0
  }
  interface {
    id = 1
    ip_address = var.peer_gateway_ip_1
  }
}
resource "google_compute_vpn_tunnel" "tunnel0" {
  name = "${var.name}-tunnel0"
  region = var.region
  vpn_gateway = google_compute_ha_vpn_gateway.this.id
  vpn_gateway_interface = 0
  peer_external_gateway = google_compute_external_vpn_gateway.peer.id
  peer_external_gateway_interface = 0
  router = google_compute_router.this.id
  shared_secret = random_password.vpn.result
}
resource "google_compute_vpn_tunnel" "tunnel1" {
  name = "${var.name}-tunnel1"
  region = var.region
  vpn_gateway = google_compute_ha_vpn_gateway.this.id
  vpn_gateway_interface = 1
  peer_external_gateway = google_compute_external_vpn_gateway.peer.id
  peer_external_gateway_interface = 1
  router = google_compute_router.this.id
  shared_secret = random_password.vpn.result
}
resource "random_password" "vpn" {
  length = 32
  special = false
}
output "vpn_gateway_id" { value = google_compute_ha_vpn_gateway.this.id }
output "router_name" { value = google_compute_router.this.name }
