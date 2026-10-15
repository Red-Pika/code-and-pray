# Environments, remote state, drift, and deployment controls

## Environment isolation

Use separate state per environment: `dev`, `staging`, `uat`, and `prod`. Do not share a state file between environments. Keep non-secret values in versioned `*.tfvars.example` files; inject secrets through the CI secret store.

## Remote state

Configure a remote backend for each root module. Recommended choices include S3 with versioning and locking for AWS, Azure Blob Storage with a private storage account for Azure, and a GCS bucket with versioning for GCP. Bootstrap the backend separately to avoid a circular dependency. Do not commit state files.

## Plan, apply, and drift

1. Run `terraform fmt -check -recursive`.
2. Run `terraform init` and `terraform validate` per root module.
3. Review `terraform plan` as a pull-request artifact.
4. Require explicit approval before production apply.
5. Run scheduled plans with read-only credentials to detect drift; do not automatically apply drift corrections.

## Existing resources and migration

Use `terraform import` or import blocks to adopt existing infrastructure. Inventory dependencies, state ownership, naming, IAM, DNS, and rollback steps before migration. Importing does not automatically generate a complete or safe configuration.

## Policy, testing, and cost controls

Add static checks for public exposure, encryption, tags, and deletion protection. Integration tests require a dedicated sandbox account/project/subscription, explicit budget limits, and cleanup. Do not run destructive tests in production.
