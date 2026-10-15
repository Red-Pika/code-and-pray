terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }
}
provider "azurerm" {
  features {}
}
variable "resource_group_name" { type = string }
variable "dns_zone_name" { type = string }
variable "record_name" { type = string }
variable "target_ipv4_address" { type = string }
resource "azurerm_dns_zone" "this" {
  name = var.dns_zone_name
  resource_group_name = var.resource_group_name
}
resource "azurerm_dns_a_record" "this" {
  name = var.record_name
  zone_name = azurerm_dns_zone.this.name
  resource_group_name = var.resource_group_name
  ttl = 300
  records = [var.target_ipv4_address]
}
output "record_fqdn" { value = azurerm_dns_a_record.this.fqdn }
