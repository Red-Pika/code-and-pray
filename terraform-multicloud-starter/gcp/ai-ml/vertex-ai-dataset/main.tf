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
variable "dataset_name" { type = string
  default = "starter-image-dataset"
}
resource "google_vertex_ai_dataset" "this" {
  display_name = var.dataset_name
  region = var.region
  metadata_schema_uri = "gs://google-cloud-aiplatform/schema/dataset/metadata/image_1.0.0.yaml"
}
output "dataset_id" { value = google_vertex_ai_dataset.this.name }
