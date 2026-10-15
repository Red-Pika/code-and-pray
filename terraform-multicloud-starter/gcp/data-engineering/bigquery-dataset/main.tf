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
variable "dataset_id" { type = string
  default = "starter_analytics"
}
resource "google_bigquery_dataset" "this" {
  dataset_id = var.dataset_id
  location = "asia-southeast2"
  description = "Starter analytics dataset"
  delete_contents_on_destroy = false
}
output "dataset_id" { value = google_bigquery_dataset.this.dataset_id }
