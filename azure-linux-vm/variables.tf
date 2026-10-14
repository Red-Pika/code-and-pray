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
  description = "Azure VM size (vCPU/RAM), e.g. Standard_B2s = 2 vCPU / 4 GiB"
  type        = string
  default     = "Standard_B2s"
}

variable "disk_size_gb" {
  type    = number
  default = 30
}

variable "disk_type" {
  description = "OS disk SKU"
  type        = string
  default     = "Premium_LRS"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key" {
  description = "Contents of your id_rsa.pub / id_ed25519.pub"
  type        = string
}

variable "ssh_cidr" {
  type    = string
  default = "0.0.0.0/0"
}
