variable "bucket_name" {
  description = "Globally unique bucket name"
  type        = string
}

variable "location" {
  description = "Bucket location, e.g. ASIA-SOUTHEAST2, ASIA, US"
  type        = string
  default     = "ASIA-SOUTHEAST2"
}

variable "storage_class" {
  type    = string
  default = "STANDARD"
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "nearline_after_days" {
  type    = number
  default = 30
}

variable "delete_after_days" {
  type    = number
  default = 365
}

variable "kms_key_name" {
  description = "Optional CMEK key. The GCS service agent needs encrypt/decrypt on it."
  type        = string
  default     = null
}
