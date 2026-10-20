variable "name" {
  type    = string
  default = "app"
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "az_count" {
  description = "Number of AZs (1-3)"
  type        = number
  default     = 2
  validation {
    condition     = var.az_count >= 1 && var.az_count <= 3
    error_message = "az_count must be between 1 and 3."
  }
}

variable "enable_nat" {
  description = "Create a single NAT gateway for private subnets (costs money)"
  type        = bool
  default     = true
}
