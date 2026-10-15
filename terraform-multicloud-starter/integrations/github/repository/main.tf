terraform {
  required_version = ">= 1.5.0"
  required_providers {
    github = { source = "integrations/github", version = "~> 6.0" }
  }
}
variable "github_token" { type = string
  sensitive = true }
variable "repository_name" { type = string
  default = "terraform-managed-example" }
variable "description" { type = string
  default = "Repository managed by Terraform" }
provider "github" { token = var.github_token }
resource "github_repository" "this" {
  name = var.repository_name
  description = var.description
  visibility = "private"
  has_issues = true
  has_projects = false
  has_wiki = false
  vulnerability_alerts = true
  delete_branch_on_merge = true
}
output "repository_html_url" { value = github_repository.this.html_url }
