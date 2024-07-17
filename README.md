# Terraform Module for provisioning GKE Autopilot

This Terraform module creates a Google Kubernetes Engine (GKE) Autopilot cluster in a specified project, region and network. It supports public and private clusters with optional NAT gateway and bastion host.

## Variables
- `project_id`: The ID of the project where the cluster will be created.
- `network_name`: The name of the network where the cluster will be created.
- `subnet_name`: The name of the subnet where the cluster will be created.
- `region`: The region where the cluster will be created.
- `name`: The name of the cluster.
- `description`: The description of the cluster.
- `is_private`: Whether the cluster should be private.
- `release_channel` (Optional): The release channel of the cluster (Default: `STABLE`).
- `network_tags` (Optional): List of network tags to apply to the cluster nodes.
- `fleet_project` (Optional): The project where the fleet is located.
- `deletion_protection` (Optional): Whether to enable deletion protection for the cluster (Default: `false`).
- `deploy_nat` (Optional): Whether to deploy a NAT gateway for the cluster.
- `router_name` (Optional): The name of the Cloud Router for the NAT gateway.
- `bastion_zone` (Optional): The zone where the bastion host will be created (Default: `${var.region}-a`).
- `bastion_members`: List of IAM members with access to the bastion host, should be specified if `is_private` is `true`.

## Example

Public Cluster:
```hcl
module "public_gke_autopilot" {
  source  = "layer-3/autopilot/google"

  project_id   = "my-project"
  network_name = "my-network"
  subnet_name  = "my-subnet"
  region       = "us-central1"

  name        = "my-cluster"
  description = "My Public GKE Autopilot cluster"
  is_private  = false
  deploy_nat  = true
}
```

Private Cluster:
```hcl
module "private_gke_autopilot" {
  source  = "layer-3/autopilot/google"

  project_id   = "my-project"
  network_name = "my-network"
  subnet_name  = "my-subnet"
  region       = "us-central1"

  name        = "my-cluster"
  description = "My Private GKE Autopilot cluster"
  is_private  = true
  deploy_nat  = true

  bastion_zone    = "us-central1-a"
  bastion_members = [
    "user:my-email@example.com"
  ]
}
```

## Author

This module is maintained by [philanton](https://github.com/philanton).

## License

This module is licensed under the MIT License.
