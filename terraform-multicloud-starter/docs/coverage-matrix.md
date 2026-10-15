# Coverage matrix for the 86 requested capabilities

Legend: **Example** = representative configuration; **Pattern** = guidance/CI/docs; **Backlog** = needs a dedicated provider-specific module and validation.

| # | Capability | Coverage | Location / note |
|---:|---|---|---|
| 1 | VPC / VNet | Example | AWS/Azure/GCP networking |
| 2 | Public/private subnets | Example | Provider networking roots |
| 3 | Route tables | Example | AWS route tables; Azure/GCP routing varies |
| 4 | Internet Gateway | Example | AWS IGW; Azure/GCP native routing |
| 5 | NAT Gateway | Example | AWS NAT Gateway; Azure NAT; GCP Cloud NAT |
| 6 | Firewall / security groups | Example | AWS SG, Azure NSG, GCP firewall |
| 7 | VPN | Backlog | Requires tunnel and gateway inputs |
| 8 | VPC peering | Example | GCP peering example; AWS/Azure backlog |
| 9 | Load balancer | Backlog | Needs provider and application requirements |
| 10 | DNS records | Backlog | Route 53 / Azure DNS / Cloud DNS |
| 11 | Object storage | Example | S3, Azure Storage, GCS |
| 12 | Block storage | Example | EBS, Managed Disk, Persistent Disk |
| 13 | Storage lifecycle | Example | Provider lifecycle policies |
| 14 | Managed database | Example | RDS, Azure SQL, Cloud SQL |
| 15 | Amazon RDS | Example | `aws/database` |
| 16 | Azure SQL | Example | `azure/database` |
| 17 | Google Cloud SQL | Example | `gcp/database` |
| 18 | Database backups | Example | Native backup retention settings |
| 19 | Database HA | Example | Provider HA settings in database examples |
| 20 | Kubernetes cluster | Example | EKS, AKS, GKE roots |
| 21 | Amazon EKS | Example | `aws/compute/eks` |
| 22 | Azure AKS | Example | `azure/compute/aks` |
| 23 | Google GKE | Example | `gcp/compute/gke` |
| 24 | Kubernetes resources | Backlog | Requires Kubernetes/Helm provider design |
| 25 | Container registry | Backlog | ECR / ACR / Artifact Registry |
| 26 | Amazon ECS | Backlog | Requires workload design |
| 27 | AWS Fargate | Backlog | ECS/Fargate workload module |
| 28 | Autoscaling group | Example | EKS node group pattern; general ASG backlog |
| 29 | IAM users/roles/policies | Example | EKS role patterns; dedicated modules backlog |
| 30 | Access and permissions | Pattern | Least-privilege review required |
| 31 | KMS encryption keys | Backlog | KMS / Key Vault / Cloud KMS modules |
| 32 | Secret Manager integration | Backlog | Secrets Manager / Key Vault / Secret Manager |
| 33 | High availability | Example | Multi-zone database and Kubernetes patterns |
| 34 | Multi-AZ | Example | Provider database HA settings |
| 35 | Multi-region | Backlog | Requires explicit failover design |
| 36 | Disaster recovery | Backlog | Needs RPO/RTO and failover strategy |
| 37 | Backup infrastructure | Pattern | Native database backups; full platform backlog |
| 38 | Monitoring infrastructure | Example | AWS CloudWatch starter |
| 39 | Logging infrastructure | Example | CloudWatch; Azure/GCP extension backlog |
| 40 | Alerting | Example | CloudWatch alarm; notification target required |
| 41 | AWS cloud management | Example | AWS roots |
| 42 | Azure cloud management | Example | Azure roots |
| 43 | GCP cloud management | Example | GCP roots |
| 44 | Multi-cloud | Pattern | Separate roots and CI; no atomic cross-cloud transaction |
| 45 | Hybrid cloud | Backlog | Requires connectivity, identity, DNS, and routing design |
| 46 | Cloudflare | Backlog | Provider credentials and zone IDs required |
| 47 | GitHub resources | Pattern | GitHub Actions example; provider resources backlog |
| 48 | Datadog resources | Backlog | API/app keys and service configuration required |
| 49 | SaaS providers | Pattern | Add provider modules after requirements are defined |
| 50 | Dev environment | Pattern | Example variable templates |
| 51 | Staging environment | Pattern | Separate state and tfvars |
| 52 | UAT environment | Pattern | Separate state and tfvars |
| 53 | Production environment | Pattern | Approval and state isolation guidance |
| 54 | Reusable modules | Pattern | Provider roots can be modularized further |
| 55 | Automated provisioning | Pattern | Terraform workflow documented |
| 56 | CI/CD integration | Example | GitHub Actions, GitLab CI, Jenkins |
| 57 | GitHub Actions | Example | `ci/github-actions/terraform.yml` |
| 58 | GitLab CI | Example | `ci/.gitlab-ci.yml` |
| 59 | Jenkins | Example | `ci/Jenkinsfile` |
| 60 | Remote state | Pattern | Backend examples and safety guidance |
| 61 | Drift detection | Pattern | Scheduled plan requires provider credentials |
| 62 | Import existing resources | Pattern | Import guidance |
| 63 | terraform plan | Pattern | Quick start and CI |
| 64 | Resource lifecycle | Pattern | Resource-specific lifecycle decisions required |
| 65 | Tagging/naming | Example | Common tags/labels in sample resources |
| 66 | Governance | Pattern | Policy examples and review guidance |
| 67 | Configuration validation | Example | CI fmt/validate workflow |
| 68 | Deployment automation | Example | CI checks; apply intentionally not automatic |
| 69 | Standard templates | Pattern | Provider root templates |
| 70 | Self-service provisioning | Backlog | Requires portal/API/catalog and guardrails |
| 71 | Cloud migration | Backlog | Needs source inventory and migration plan |
| 72 | Certificates | Backlog | ACM / Key Vault / Certificate Manager |
| 73 | Observability | Example | AWS CloudWatch starter; Azure/GCP extension backlog |
| 74 | Cost governance | Pattern | Tags/labels and cost-control notes |
| 75 | Three-tier app | Backlog | Combine network, compute, LB, DB after app inputs |
| 76 | Microservices | Pattern | Kubernetes roots provide cluster foundation only |
| 77 | Web app | Pattern | Infrastructure building blocks included |
| 78 | Enterprise app | Backlog | Requires sizing, HA/DR, security, compliance inputs |
| 79 | AI/ML workloads | Backlog | GPU, IAM, storage, networking, quota requirements |
| 80 | Data engineering | Backlog | Managed data services and pipeline design needed |
| 81 | Network/security resources | Example | Provider networking roots |
| 82 | Sandbox automation | Pattern | Reuse roots with short-lived state and budget controls |
| 83 | Modules/workspaces | Pattern | Guidance; separate state recommended per environment |
| 84 | Policy as code | Example | `policies/` starter guardrail |
| 85 | Infrastructure testing | Pattern | CI fmt/validate; integration tests need credentials |
| 86 | Consistent IaC management | Pattern | Formatting, validation, naming, CI examples |

## Important

The matrix is explicit about gaps. A capability is not production-ready until provider resources, variables, permissions, tests, and operational runbooks are implemented and verified.
