variable "name" {
  type    = string
  default = "app"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.50.1.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.50.11.0/24"
}

variable "enable_nat" {
  description = "Cloud NAT for the private subnet (costs money)"
  type        = bool
  default     = true
}
