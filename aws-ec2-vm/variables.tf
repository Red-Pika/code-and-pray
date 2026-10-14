variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "name" {
  description = "Name tag for the instance"
  type        = string
  default     = "app-vm"
}

variable "instance_type" {
  description = "EC2 instance type (encodes vCPU and RAM, e.g. t3.medium = 2 vCPU / 4 GiB)"
  type        = string
  default     = "t3.medium"
}

variable "disk_size_gb" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 30
}

variable "disk_type" {
  description = "Root EBS volume type"
  type        = string
  default     = "gp3"
}

variable "associate_public_ip" {
  type    = bool
  default = true
}

variable "ssh_cidr" {
  description = "CIDR allowed to SSH (port 22). Restrict this in production."
  type        = string
  default     = "0.0.0.0/0"
}

