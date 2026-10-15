terraform {
  required_version = ">= 1.5.0"
  required_providers {
    cloudflare = { source = "cloudflare/cloudflare", version = "~> 4.0" }
  }
}
variable "cloudflare_api_token" {
  type = string
  sensitive = true
  }
variable "zone_id" { type = string }
variable "record_name" { type = string }
variable "record_value" { type = string }
variable "proxied" {
  type = bool
  default = false
  }
provider "cloudflare" { api_token = var.cloudflare_api_token }
resource "cloudflare_record" "this" {
  zone_id = var.zone_id
  name = var.record_name
  type = "CNAME"
  value = var.record_value
  proxied = var.proxied
  ttl = var.proxied ? 1 : 300
}
output "record_id" { value = cloudflare_record.this.id }
