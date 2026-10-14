output "vm_id" {
  value = azurerm_linux_virtual_machine.app.id
}

output "public_ip" {
  value = azurerm_public_ip.app.ip_address
}

output "size" {
  value = azurerm_linux_virtual_machine.app.size
}
