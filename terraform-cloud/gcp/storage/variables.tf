variable "name" {
  type    = string
  default = "app-data"
}

variable "zone" {
  type    = string
  default = "asia-southeast2-a"
}

variable "size_gb" {
  type    = number
  default = 50
}

variable "disk_type" {
  description = "pd-balanced, pd-ssd, pd-standard"
  type        = string
  default     = "pd-balanced"
}

variable "kms_key_id" {
  description = "Optional Cloud KMS key for CMEK. null = Google-managed key"
  type        = string
  default     = null
}

variable "snapshot_retention_days" {
  type    = number
  default = 14
}
