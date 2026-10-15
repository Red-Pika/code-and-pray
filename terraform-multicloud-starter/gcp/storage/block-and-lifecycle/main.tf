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
variable "bucket_name" {
  type = string
  description = "Globally unique GCS bucket name"
}
resource "google_storage_bucket" "this" {
  name = var.bucket_name
  location = "ASIA-SOUTHEAST2"
  uniform_bucket_level_access = true
  public_access_prevention = "enforced"
  force_destroy = false
  versioning { enabled = true }
  lifecycle_rule {
    condition { age = 30 }
    action {
      type = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
  lifecycle_rule {
    condition { age = 365 }
    action { type = "Delete" }
  }
}
resource "google_compute_disk" "this" {
  name = "starter-data-disk"
  type = "pd-balanced"
  zone = "${var.region}-a"
  size = 20
}
output "bucket_name" { value = google_storage_bucket.this.name }
output "disk_id" { value = google_compute_disk.this.id }
