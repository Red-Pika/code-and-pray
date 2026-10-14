variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "name" {
  type    = string
  default = "app"
}

variable "instance_type" {
  description = "Launch template instance type"
  type        = string
  default     = "t3.medium"
}

variable "disk_size_gb" {
  type    = number
  default = 30
}

variable "disk_type" {
  type    = string
  default = "gp3"
}

variable "min_size" {
  type    = number
  default = 1
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 4
}

variable "cpu_target" {
  description = "ASG average CPU percent to hold"
  type        = number
  default     = 50
}

variable "ssh_cidr" {
  type    = string
  default = "0.0.0.0/0"
}
