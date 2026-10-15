# Implementation status

The scope is the 86 capabilities in [coverage-matrix.md](coverage-matrix.md). This branch now contains examples for the network, storage, security, compute/container, registry, observability, and SaaS integration areas.

This is **not yet a claim of 86 production-ready implementations**. Some capabilities inherently require design inputs, including VPN peers, hybrid routing, active/active multi-region, disaster recovery RPO/RTO, enterprise/AI/data workload sizing, self-service portals, and migration inventory. Provider modules also require credentialed testing in the target accounts.

## Validate locally

Run the commands separately in each module directory:

```bash
terraform fmt -recursive
terraform init -backend=false
terraform validate
terraform plan
```

Use the plan only after reviewing variable values, provider permissions, public exposure, data retention, deletion protection, and expected costs. Do not run `terraform apply` without explicit review and authorization.
