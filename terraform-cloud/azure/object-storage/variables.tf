variable "resource_group_name" {
  type = string
}

variable "storage_account_name" {
  description = "Globally unique, 3-24 chars, lowercase letters and numbers only"
  type        = string
}

variable "container_name" {
  type    = string
  default = "data"
}

variable "replication_type" {
  description = "LRS, ZRS, GRS, RAGRS, GZRS, RAGZRS"
  type        = string
  default     = "LRS"
}

variable "public_network_access_enabled" {
  description = "Set false and add private endpoints for production"
  type        = bool
  default     = true
}

variable "tier_to_cool_days" {
  type    = number
  default = 30
}

variable "tier_to_archive_days" {
  type    = number
  default = 90
}

variable "delete_after_days" {
  type    = number
  default = 365
}
