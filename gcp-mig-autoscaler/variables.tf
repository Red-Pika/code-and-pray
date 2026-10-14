variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "asia-southeast2"
}

variable "name" {
  type    = string
  default = "app"
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "disk_size_gb" {
  type    = number
  default = 30
}

variable "disk_type" {
  type    = string
  default = "pd-balanced"
}

variable "min_replicas" {
  type    = number
  default = 1
}

variable "max_replicas" {
  type    = number
  default = 4
}

variable "cpu_target" {
  description = "CPU utilization target 0.0–1.0"
  type        = number
  default     = 0.5
}
