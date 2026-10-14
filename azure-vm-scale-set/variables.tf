variable "subscription_id" {
  description = "Azure subscription ID (required by azurerm 4.x)"
  type        = string
}

variable "location" {
  type    = string
  default = "Southeast Asia"
}

variable "name" {
  type    = string
  default = "app"
}

variable "vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "disk_size_gb" {
  type    = number
  default = 30
}

variable "disk_type" {
  type    = string
  default = "Premium_LRS"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key" {
  type = string
}

variable "min_instances" {
  type    = number
  default = 1
}

variable "desired_instances" {
  type    = number
  default = 2
}

variable "max_instances" {
  type    = number
  default = 4
}

variable "cpu_target" {
  type    = number
  default = 50
}
