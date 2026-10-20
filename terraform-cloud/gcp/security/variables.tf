variable "name" {
  type    = string
  default = "app"
}

variable "network_name" {
  description = "VPC network name (output of gcp/network)"
  type        = string
}

variable "allowed_https_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "kms_location" {
  description = "KMS location. Key rings can never be deleted, so pick carefully."
  type        = string
  default     = "asia-southeast2"
}
