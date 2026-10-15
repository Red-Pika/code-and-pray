# Advanced capability implementation notes

The following capabilities need workload-specific values or operational decisions before production deployment:

- **Multi-region and disaster recovery:** define RPO/RTO, active/passive versus active/active, data replication, failover, and failback.
- **Hybrid cloud and VPN:** provide peer public IPs, on-premises CIDRs, BGP ASN, route propagation, and firewall rules. VPN examples are starting points and must be coordinated with the remote network team.
- **Three-tier / enterprise applications:** provide application ports, health checks, private subnet plan, scaling targets, database sizing, TLS domains, and compliance requirements.
- **AI/ML and data engineering:** GPU/accelerator quotas, model/data sensitivity, storage locations, data pipeline topology, and cost limits must be specified.
- **Self-service provisioning:** Terraform modules are infrastructure building blocks; a service catalog or portal/API and authorization model are separate application work.
- **Migration:** inventory current resources, dependencies, DNS, identity, data transfer, rollback and cutover requirements before generating migration-specific configuration.
- **Cost governance:** configure provider budgets and alerts per billing account/subscription/project; budgets are not hard spending caps.
- **Security:** do not pass secrets as literals. Use the cloud secret manager or CI secret store, and restrict state access because state can contain sensitive values.
