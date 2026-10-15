# Reference patterns: three-tier, multi-region, and disaster recovery

## Three-tier application

Use separate public and private subnets, a public load balancer in front of the web tier, private application instances or containers, and a managed database reachable only from the application security group. Keep database credentials in the provider secret manager. Add TLS certificates and DNS records from the certificate/DNS modules. Do not reuse example CIDRs without checking for overlap.

## Multi-region

The provider modules are independent roots. A multi-region deployment needs explicit choices for:
- active/passive or active/active traffic management;
- data replication and consistency;
- global DNS or traffic manager behavior;
- secrets and key replication;
- region-specific quotas and service availability;
- failover and failback runbooks.

Do not assume a single Terraform state can make cross-cloud or cross-region changes atomic.

## Disaster recovery

Set measurable RPO/RTO targets before implementation. Backups alone do not prove recoverability: test restore procedures, application consistency, credentials, DNS cutover, and access paths in an isolated environment. Preserve immutable/off-account copies where required by policy.

## Sandbox and migration

Use separate state and short-lived naming for sandbox environments. For migration, inventory resources and dependencies, import existing infrastructure, compare plans, and schedule cutover/rollback. Avoid destructive replacement when adopting existing resources.
