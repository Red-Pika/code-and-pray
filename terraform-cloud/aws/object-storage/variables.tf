variable "bucket_name" {
  description = "Globally unique S3 bucket name (lowercase letters, numbers, hyphens)"
  type        = string
}

variable "kms_key_arn" {
  description = "Optional KMS key ARN for SSE-KMS. null = SSE-S3 (AES256)"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Allow terraform destroy to delete a non-empty bucket"
  type        = bool
  default     = false
}

variable "transition_days" {
  type    = number
  default = 30
}

variable "expiration_days" {
  type    = number
  default = 365
}

variable "noncurrent_expiration_days" {
  type    = number
  default = 90
}
