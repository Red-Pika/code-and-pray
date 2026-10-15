terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }
}
provider "azurerm" { features {} }
variable "location" { type = string
  default = "southeastasia"
}
variable "name" { type = string
  default = "starter-vault"
}
variable "tenant_id" { type = string }
variable "object_id" { type = string
  description = "Principal object ID that needs vault access"
}
resource "azurerm_resource_group" "this" {
  name = "${var.name}-rg"
  location = var.location
}
resource "azurerm_key_vault" "this" {
  name = var.name
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tenant_id = var.tenant_id
  sku_name = "standard"
  soft_delete_retention_days = 90
  purge_protection_enabled = true
  enable_rbac_authorization = true
}
resource "azurerm_role_assignment" "certificates_officer" {
  scope = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Certificates Officer"
  principal_id = var.object_id
}
output "key_vault_id" { value = azurerm_key_vault.this.id }
