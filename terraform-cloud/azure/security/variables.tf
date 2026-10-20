variable "name" {
  type    = string
  default = "app"
}

variable "resource_group_name" {
  description = "Existing resource group (e.g. output of azure/network)"
  type        = string
}

variable "key_vault_name" {
  description = "Globally unique Key Vault name, 3-24 chars, letters/numbers/hyphens"
  type        = string
}

variable "allowed_https_source" {
  description = "Source address prefix allowed on 443 (Internet, a CIDR, or a service tag)"
  type        = string
  default     = "Internet"
}

variable "purge_protection_enabled" {
  description = "Keep true for production; true prevents re-using the vault name after delete"
  type        = bool
  default     = true
}
