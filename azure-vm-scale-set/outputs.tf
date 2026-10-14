output "vmss_id" {
  value = azurerm_linux_virtual_machine_scale_set.app.id
}

output "sku" {
  value = azurerm_linux_virtual_machine_scale_set.app.sku
}
