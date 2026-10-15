# Terraform Multi-Cloud Infrastructure Starter Kit

Reusable Terraform examples organized by cloud provider: AWS, Azure, and Google Cloud Platform (GCP).

> **Status and safety:** This is a starter kit, not a claim that all 86 requested capabilities are implemented as production-ready modules. It contains representative building blocks plus a coverage map and implementation backlog. The examples have not been run against real cloud accounts. Review provider versions, quotas, costs, and security before applying.

## Intended layout

- `aws/`: networking, S3/EBS, RDS, EKS, observability
- `azure/`: networking, Storage/Managed Disk, Azure SQL, AKS
- `gcp/`: networking, GCS/Persistent Disk, Cloud SQL, GKE
- `examples/`: environment and backend templates
- `ci/`: GitHub Actions, GitLab CI, Jenkins examples
- `policies/`: example policy-as-code guardrails
- `docs/`: coverage matrix and deployment guidance

## Requirements

- Terraform CLI >= 1.6.0
- Cloud CLI and credentials for the target provider
- An isolated sandbox account/project/subscription for initial testing

## Quick start

Choose **one** stack at a time. Each cloud directory is an independent root module; do not run Terraform from the repository root.

```bash
cd aws/networking
cp terraform.tfvars.example terraform.tfvars
# Edit required values, especially region and CIDR ranges.
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

Authenticate before using Azure (`az login`) or GCP (`gcloud auth application-default login`). Use an approved AWS profile, environment, or workload identity.

**Never commit credentials, `terraform.tfstate`, `.tfplan`, or real `terraform.tfvars` files.**

## Cost and security notes

- NAT Gateways, managed databases, Kubernetes clusters, load balancers, disks, logging, and cross-region replication can incur charges.
- `terraform destroy` may delete data-bearing resources. Review the plan and backups before destroying anything.
- Restrict CIDR ranges and ingress rules before production use.
- Production use requires review of private endpoints, encryption, audit logs, state locking, backup retention, IAM least privilege, policy enforcement, and disaster recovery tests.

## Validation status

Terraform CLI was not available in the build environment, and no cloud credentials/accounts were provided, so `terraform validate`, `plan`, and real deployment have **not** been executed. Run checks in your own CI or workstation before applying.

## Scope

See `docs/coverage-matrix.md` for mapping the 86 requested capabilities to examples, shared patterns, or backlog items. Some capabilities (VPN, multi-cloud orchestration, SaaS integrations, and self-service portals) require additional provider-specific modules and architecture decisions.


## Expanded capability modules

The branch now has separate examples for the 86-item scope documented in [the coverage matrix](docs/coverage-matrix.md). New example roots include:

- Networking: VPC/VNet, public/private subnet patterns, NAT, peering, site-to-site/HA VPN, load balancers, DNS
- Storage: object storage lifecycle and encrypted block disks
- Security: security groups/NSGs/firewalls, KMS/Key Vault/Secret Manager, certificates, backup vaults
- Compute and containers: EC2/VM building blocks, EKS/AKS/GKE, ECS/Fargate, Azure Container Apps, Cloud Run, registries
- Data: RDS, Azure SQL, Cloud SQL, Glue Catalog, Data Factory, BigQuery dataset
- Operations: monitoring/logging/alerts, budgets, policy-as-code, CI/CD, environment/state/drift/import guidance
- Integrations: Cloudflare DNS, Datadog monitor, GitHub repository

Each directory containing a `.tf` file is an independent Terraform root. Initialize and validate modules separately. Do not run `terraform apply` from the repository root.

## Validation and completeness

GitHub Actions is configured to format and validate the independent root modules. Check the [workflow run history](https://github.com/Red-Pika/code-and-pray/actions/workflows/terraform.yml) for actual results. A passing `terraform validate` proves configuration structure/provider schema only; it does not verify cloud permissions, quotas, runtime behavior, security posture, or cost.

The 86-item list is the scope baseline, not a claim that every item is production-complete. Hybrid networking, multi-region failover, DR RPO/RTO, enterprise workload sizing, self-service portals, and migration/cutover plans require environment-specific design and testing.
