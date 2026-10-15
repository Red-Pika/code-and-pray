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
  default = "starter-sql"
}
variable "administrator_login" {
  type = string
  default = "sqladminuser"
}
variable "administrator_password" {
  type = string
  sensitive = true
  description = "Inject from a secret store; never commit this value"
}
resource "azurerm_resource_group" "this" {
  name = "${var.name}-rg"
  location = var.location
}
resource "azurerm_mssql_server" "this" {
  name = var.name
  resource_group_name = azurerm_resource_group.this.name
  location = azurerm_resource_group.this.location
  version = "12.0"
  administrator_login = var.administrator_login
  administrator_login_password = var.administrator_password
  minimum_tls_version = "1.2"
  public_network_access_enabled = false
}
resource "azurerm_mssql_database" "this" {
  name = "${var.name}-db"
  server_id = azurerm_mssql_server.this.id
  sku_name = "Basic"
  storage_account_type = "Local"
  zone_redundant = false
}
output "sql_server_fqdn" { value = azurerm_mssql_server.this.fully_qualified_domain_name }
