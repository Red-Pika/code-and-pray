variable "name" {
  type    = string
  default = "app-data"
}

variable "resource_group_name" {
  type = string
}

variable "size_gb" {
  type    = number
  default = 64
}

variable "disk_type" {
  description = "Premium_LRS, StandardSSD_LRS, Standard_LRS, PremiumV2_LRS, ..."
  type        = string
  default     = "StandardSSD_LRS"
}

variable "zone" {
  description = "Availability zone (\"1\", \"2\", \"3\") or null. Must match the VM zone."
  type        = string
  default     = null
}

variable "disk_encryption_set_id" {
  description = "Optional customer-managed key encryption set. null = platform-managed key"
  type        = string
  default     = null
}
