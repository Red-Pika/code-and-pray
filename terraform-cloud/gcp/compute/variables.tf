variable "name" {
  type    = string
  default = "app-vm"
}

variable "zone" {
  type    = string
  default = "asia-southeast2-a"
}

variable "network" {
  description = "VPC self link or name"
  type        = string
}

variable "subnetwork" {
  description = "Subnet self link"
  type        = string
}

variable "machine_type" {
  description = "e2-medium = 2 vCPU / 4 GiB"
  type        = string
  default     = "e2-medium"
}

variable "boot_disk_size_gb" {
  type    = number
  default = 30
}

variable "boot_disk_type" {
  type    = string
  default = "pd-balanced"
}

variable "assign_public_ip" {
  type    = bool
  default = false
}

variable "service_account_email" {
  description = "Service account for the VM (e.g. output of gcp/security). null = default compute SA"
  type        = string
  default     = null
}

variable "network_tags" {
  description = "Tags matching firewall rules, e.g. iap-ssh, https-server"
  type        = list(string)
  default     = ["iap-ssh"]
}
