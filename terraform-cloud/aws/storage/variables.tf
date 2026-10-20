variable "name" {
  type    = string
  default = "app-data"
}

variable "availability_zone" {
  description = "AZ of the EBS volume; must match the instance it will attach to"
  type        = string
  default     = "ap-southeast-1a"
}

variable "size_gb" {
  type    = number
  default = 50
}

variable "volume_type" {
  type    = string
  default = "gp3"
}

variable "kms_key_id" {
  description = "Optional KMS key ARN. null = AWS managed EBS key"
  type        = string
  default     = null
}

variable "snapshot_retention_count" {
  type    = number
  default = 7
}
