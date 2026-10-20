# terraform-cloud

Terraform per cloud and per category. **Every folder is an independent root module** with its own state:
`providers.tf`, `variables.tf`, `main.tf`, `outputs.tf`.

| Category | AWS | Azure | GCP |
|---|---|---|---|
| network | `aws/network` VPC, public/private subnets, IGW, NAT, routes | `azure/network` RG, VNet, subnets, NAT gateway | `gcp/network` VPC, subnets, Cloud Router + NAT |
| security | `aws/security` SGs, KMS, Secrets Manager | `azure/security` NSG, Key Vault (RBAC), managed identity | `gcp/security` firewall, IAP SSH, service account, KMS, Secret Manager |
| compute | `aws/compute` EC2 (IMDSv2, SSM, encrypted root) | `azure/compute` Linux VM (SSH key only) | `gcp/compute` GCE (shielded VM, OS Login) |
| storage (block) | `aws/storage` EBS + DLM snapshots | `azure/storage` Managed Disk | `gcp/storage` Persistent Disk + snapshot schedule |
| object-storage | `aws/object-storage` S3 | `azure/object-storage` Storage Account + container | `gcp/object-storage` GCS |

## Usage (one folder at a time)

```bash
cd aws/network
terraform init
terraform plan  -var 'name=demo'
terraform apply -var 'name=demo'
```

Required variables have no default (for example `aws/compute` needs `vpc_id` and `subnet_id`;
`azure/*` needs `subscription_id`; `gcp/*` needs `project_id`). Pass them with `-var` or a `terraform.tfvars` file.

Suggested order: **network -> security -> compute / storage**. Feed outputs from earlier modules
(`vpc_id`, `private_subnet_ids`, `resource_group_name`, `network_name`, ...) into later ones.
For cross-module wiring in real use, add remote state (`terraform_remote_state`) or compose them as modules.

Auth: AWS profile/env, `az login`, `gcloud auth application-default login`.

## Validate

```bash
./scripts/validate.sh   # fmt -check + init -backend=false + validate for every module
```

## Notes

- **Not run against real accounts**, and `terraform validate` was not executed when these were generated
  (no Terraform CLI in the build environment). Run `scripts/validate.sh` and review `terraform plan` before any apply.
- Costs: NAT gateways, KMS keys, disks, VMs. `enable_nat = false` skips NAT.
- Defaults are secure-by-default (encryption on, no public SSH, public access blocked, versioning on).
  Review variables such as `allowed_https_cidrs` before production.
- GCP KMS key rings and Azure Key Vault names (with purge protection) cannot be reused after deletion.
- Secret **values** are not managed in Terraform on purpose, to keep them out of state.
- Use a remote backend (S3 / Azure Blob / GCS) with locking for anything beyond experiments.
