variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "asia-southeast2"
}

variable "zone" {
  type    = string
  default = "asia-southeast2-a"
}

variable "name" {
  type    = string
  default = "app-vm"
}

variable "machine_type" {
  description = "GCE machine type (vCPU/RAM), e.g. e2-medium = 2 vCPU / 4 GiB"
  type        = string
  default     = "e2-medium"
}

variable "disk_size_gb" {
  type    = number
  default = 30
}

variable "disk_type" {
  type    = string
  default = "pd-balanced"
}

variable "ssh_cidr" {
  type    = string
  default = "0.0.0.0/0"
}
