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
variable "bucket_name" { type = string
  description = "Globally unique bucket name" }
resource "google_storage_bucket" "this" {
  name = var.bucket_name
  location = "ASIA-SOUTHEAST2"
  uniform_bucket_level_access = true
  public_access_prevention = "enforced"
  force_destroy = false
  versioning { enabled = true }
}
output "bucket_name" { value = google_storage_bucket.this.name }
