variable "name" {
  type    = string
  default = "app"
}

variable "resource_group_name" {
  description = "Resource group to create. Other Azure modules reuse this name."
  type        = string
  default     = "rg-app"
}

variable "address_space" {
  type    = list(string)
  default = ["10.40.0.0/16"]
}

variable "public_subnet_prefix" {
  type    = string
  default = "10.40.1.0/24"
}

variable "private_subnet_prefix" {
  type    = string
  default = "10.40.11.0/24"
}

variable "enable_nat" {
  description = "NAT gateway for the private subnet (costs money)"
  type        = bool
  default     = true
}
