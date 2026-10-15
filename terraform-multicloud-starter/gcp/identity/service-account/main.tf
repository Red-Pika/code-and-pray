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
variable "account_id" { type = string
  default = "starter-workload"
}
resource "google_service_account" "this" {
  account_id = var.account_id
  display_name = "Terraform managed workload identity"
}
output "service_account_email" { value = google_service_account.this.email }
