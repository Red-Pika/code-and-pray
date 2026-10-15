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
variable "repository_id" { type = string
  default = "starter-containers"
}
resource "google_artifact_registry_repository" "this" {
  location = var.region
  repository_id = var.repository_id
  description = "Private container image repository"
  format = "DOCKER"
  docker_config { immutable_tags = true }
}
output "repository_name" { value = google_artifact_registry_repository.this.name }
