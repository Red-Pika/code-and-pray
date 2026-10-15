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
  default = "starter-http"
}
variable "backend_instance_group" { type = string
  description = "Self-link of a managed instance group"
}
resource "google_compute_health_check" "this" {
  name = "${var.name}-hc"
  http_health_check { port = 80
    request_path = "/"
  }
}
resource "google_compute_backend_service" "this" {
  name = "${var.name}-backend"
  protocol = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  health_checks = [google_compute_health_check.this.id]
  backend {
    group = var.backend_instance_group
    balancing_mode = "UTILIZATION"
    max_utilization = 0.8
  }
}
resource "google_compute_url_map" "this" {
  name = "${var.name}-urlmap"
  default_service = google_compute_backend_service.this.id
}
resource "google_compute_target_http_proxy" "this" {
  name = "${var.name}-proxy"
  url_map = google_compute_url_map.this.id
}
resource "google_compute_global_forwarding_rule" "this" {
  name = "${var.name}-forwarding"
  target = google_compute_target_http_proxy.this.id
  port_range = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
}
output "forwarding_rule_ip" { value = google_compute_global_forwarding_rule.this.ip_address }
