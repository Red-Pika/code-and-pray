variable "name" {
  type    = string
  default = "app"
}

variable "vpc_id" {
  description = "VPC where the security groups are created"
  type        = string
}

variable "allowed_https_cidrs" {
  description = "CIDRs allowed to reach the web tier on 443"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "app_port" {
  type    = number
  default = 8080
}
