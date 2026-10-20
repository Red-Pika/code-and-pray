variable "name" {
  type    = string
  default = "app"
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vm_size" {
  description = "Encodes vCPU/RAM, e.g. Standard_B2s = 2 vCPU / 4 GiB"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key" {
  description = "Contents of your id_ed25519.pub / id_rsa.pub"
  type        = string
}

variable "os_disk_size_gb" {
  type    = number
  default = 30
}

variable "os_disk_type" {
  type    = string
  default = "Premium_LRS"
}

variable "assign_public_ip" {
  type    = bool
  default = false
}

variable "allowed_ssh_cidrs" {
  description = "CIDRs allowed to SSH. Empty = no inbound SSH rule"
  type        = list(string)
  default     = []
}
