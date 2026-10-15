terraform {
  required_version = ">= 1.5.0"
  required_providers { azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" } }
}
provider "azurerm" {
  features {}
}
variable "location" {
  type = string
  default = "southeastasia" }
variable "name" {
  type = string
  default = "starterstorage" }
resource "azurerm_resource_group" "this" { name = "${var.name}-rg"
  location = var.location }
resource "azurerm_storage_account" "this" {
  name = var.name
  resource_group_name = azurerm_resource_group.this.name
  location = azurerm_resource_group.this.location
  account_tier = "Standard"
  account_replication_type = "LRS"
  min_tls_version = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled = false
}
resource "azurerm_storage_container" "this" {
  name = "private-data"
  storage_account_id = azurerm_storage_account.this.id
  container_access_type = "private"
}
output "storage_account_name" { value = azurerm_storage_account.this.name }
