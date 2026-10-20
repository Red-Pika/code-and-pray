terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = { source = "hashicorp/google", version = "~> 6.0" }
  }
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "asia-southeast2"
}

variable "labels" {
  description = "Labels applied to supported resources"
  type        = map(string)
  default     = { managed-by = "terraform" }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
