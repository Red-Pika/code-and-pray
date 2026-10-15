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
variable "name" { type = string
  default = "starter-peering"
}
variable "local_network_self_link" { type = string }
variable "peer_network_self_link" { type = string }
resource "google_compute_network_peering" "local_to_peer" {
  name = var.name
  network = var.local_network_self_link
  peer_network = var.peer_network_self_link
  export_custom_routes = false
  import_custom_routes = false
}
output "peering_name" { value = google_compute_network_peering.local_to_peer.name }
