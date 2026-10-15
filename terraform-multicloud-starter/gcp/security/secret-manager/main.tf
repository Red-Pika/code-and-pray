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
variable "project_id" { type = string }
variable "region" {
  type = string
  default = "asia-southeast2"
}
variable "secret_id" {
  type = string
  default = "starter-app-secret"
}
resource "google_secret_manager_secret" "this" {
  secret_id = var.secret_id
  replication {
    auto {}
  }
}
output "secret_resource_name" { value = google_secret_manager_secret.this.name }
