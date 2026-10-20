resource "azurerm_managed_disk" "this" {
  name                   = "disk-${var.name}"
  location               = var.location
  resource_group_name    = var.resource_group_name
  storage_account_type   = var.disk_type
  create_option          = "Empty"
  disk_size_gb           = var.size_gb
  zone                   = var.zone
  disk_encryption_set_id = var.disk_encryption_set_id
  tags                   = var.tags
}
