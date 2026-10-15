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
variable "service_name" {
  type = string
  default = "starter-cloud-run"
  }
variable "container_image" {
  type = string
  description = "Container image URI"
  }
resource "google_cloud_run_v2_service" "this" {
  name = var.service_name
  location = var.region
  template {
    scaling {
      min_instance_count = 0
  max_instance_count = 3
  }
    containers {
      image = var.container_image
      ports { container_port = 8080 }
    }
  }
}
output "service_uri" { value = google_cloud_run_v2_service.this.uri }
