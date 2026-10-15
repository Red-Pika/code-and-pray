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
  default = "starter-identity"
}
resource "azurerm_resource_group" "this" {
  name = "${var.name}-rg"
  location = var.location
}
resource "azurerm_user_assigned_identity" "this" {
  name = var.name
  location = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}
output "identity_id" { value = azurerm_user_assigned_identity.this.id }
output "principal_id" { value = azurerm_user_assigned_identity.this.principal_id }
