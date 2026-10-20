variable "name" {
  type    = string
  default = "app-vm"
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  description = "Subnet to launch the instance in"
  type        = string
}

variable "instance_type" {
  description = "Encodes vCPU/RAM, e.g. t3.medium = 2 vCPU / 4 GiB"
  type        = string
  default     = "t3.medium"
}

variable "root_volume_size_gb" {
  type    = number
  default = 30
}

variable "root_volume_type" {
  type    = string
  default = "gp3"
}

variable "assign_public_ip" {
  type    = bool
  default = false
}

variable "allowed_ssh_cidrs" {
  description = "CIDRs allowed to SSH. Empty = no SSH rule (use SSM Session Manager)"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "Optional EC2 key pair name"
  type        = string
  default     = null
}
