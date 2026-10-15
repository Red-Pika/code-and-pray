# Terraform Multi-Cloud Starter Kit — Status

This branch is prepared for the AWS, Azure, and GCP Terraform starter kit.

## Current status

The companion starter archive contains 81 files (about 55 KB uncompressed), including provider examples, CI templates, operational notes, and a coverage matrix for 86 requested capabilities. The archive has not yet been imported into this Git branch. This status file is not a substitute for those Terraform files.

## Important validation note

Terraform CLI was unavailable in the generation environment. The examples have not been run through `terraform fmt`, `terraform validate`, `terraform plan`, or applied to a cloud account. Treat them as a starter kit for review, not production-certified infrastructure.

## Intended layout

- `aws/`: networking, storage, database, EKS, observability
- `azure/`: networking, storage, database, AKS
- `gcp/`: networking, storage, database, GKE
- `ci/`: GitHub Actions, GitLab CI, Jenkins examples
- `docs/`: coverage matrix, operations and implementation backlog
- `policies/`: sample policy-as-code guardrails

## Safe next steps

1. Import the companion archive contents into this repository.
2. Review every provider version, variable, IAM permission, firewall rule, and resource lifecycle.
3. Run `terraform fmt -recursive` and `terraform validate` separately for each root module.
4. Review `terraform plan` and estimated cost before any `apply`.
5. Never commit credentials, real `terraform.tfvars`, or Terraform state files.
