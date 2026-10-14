resource "azurerm_resource_group" "app" {
  name     = "rg-${var.name}-vmss"
  location = var.location
}

resource "azurerm_virtual_network" "app" {
  name                = "vnet-${var.name}"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
}

resource "azurerm_subnet" "app" {
  name                 = "snet-${var.name}"
  resource_group_name  = azurerm_resource_group.app.name
  virtual_network_name = azurerm_virtual_network.app.name
  address_prefixes     = ["10.10.1.0/24"]
}

resource "azurerm_linux_virtual_machine_scale_set" "app" {
  name                = "vmss-${var.name}"
  resource_group_name = azurerm_resource_group.app.name
  location            = azurerm_resource_group.app.location
  sku                 = var.vm_size
  instances           = var.desired_instances
  admin_username      = var.admin_username
  upgrade_mode        = "Automatic"

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = var.disk_type
    caching              = "ReadWrite"
    disk_size_gb         = var.disk_size_gb
  }

  network_interface {
    name    = "nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.app.id
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [instances]
  }
}

resource "azurerm_monitor_autoscale_setting" "app" {
  name                = "autoscale-${var.name}"
  resource_group_name = azurerm_resource_group.app.name
  location            = azurerm_resource_group.app.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.app.id

  profile {
    name = "default"

    capacity {
      minimum = tostring(var.min_instances)
      default = tostring(var.desired_instances)
      maximum = tostring(var.max_instances)
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.app.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = var.cpu_target
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.app.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = max(var.cpu_target - 20, 10)
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }
}
