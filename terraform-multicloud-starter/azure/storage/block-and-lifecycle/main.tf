terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }
}
provider "azurerm" {
  features {}
}
variable "location" {
  type = string
  default = "southeastasia"
}
variable "name" {
  type = string
  default = "starterdisk"
}
resource "azurerm_resource_group" "this" {
  name = "${var.name}-rg"
  location = var.location
}
resource "azurerm_managed_disk" "this" {
  name = "${var.name}-disk"
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  storage_account_type = "StandardSSD_LRS"
  create_option = "Empty"
  disk_size_gb = 32
  encryption_settings { enabled = true }
}
resource "azurerm_storage_account" "this" {
  name = var.name
  resource_group_name = azurerm_resource_group.this.name
  location = azurerm_resource_group.this.location
  account_tier = "Standard"
  account_replication_type = "LRS"
  min_tls_version = "TLS1_2"
  allow_nested_items_to_be_public = false
}
resource "azurerm_storage_management_policy" "this" {
  storage_account_id = azurerm_storage_account.this.id
  rule {
    name = "tier-old-blobs"
    enabled = true
    filters { blob_types = ["blockBlob"] }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than = 30
        tier_to_archive_after_days_since_modification_greater_than = 90
        delete_after_days_since_modification_greater_than = 365
      }
    }
  }
}
output "managed_disk_id" { value = azurerm_managed_disk.this.id }
output "storage_account_id" { value = azurerm_storage_account.this.id }
