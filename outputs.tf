output "cluster_name" {
  description = "Cluster name"
  value       = google_container_cluster.this.name
}

output "bastion_host" {
  description = "The bastion host for the cluster"
  value       = var.is_private ? local.bastion_name : ""
}

output "endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = google_container_cluster.this.endpoint
}

output "router_name" {
  description = "Name of the router that was created"
  value       = local.router_name
}

output "get_credentials_command" {
  description = "gcloud get-credentials command to generate kubeconfig"
  value = var.is_private ? format(
    "gcloud container clusters get-credentials %s --project %s --zone %s --internal-ip", google_container_cluster.this.name, var.project_id, var.region
    ) : format(
    "gcloud container clusters get-credentials %s --project %s --zone %s", google_container_cluster.this.name, var.project_id, var.region
  )
}

output "bastion_name" {
  description = "Name of the bastion host"
  value       = var.is_private ? module.bastion[0].hostname : ""
}

output "bastion_zone" {
  description = "Location of bastion host"
  value       = var.is_private ? local.bastion_zone : ""
}

output "bastion_ssh_command" {
  description = "gcloud command to ssh and port forward to the bastion host command"
  value       = var.is_private ? format("gcloud beta compute ssh %s --tunnel-through-iap --project %s --zone %s -- -L8888:127.0.0.1:8888", module.bastion[0].hostname, var.project_id, local.bastion_zone) : ""
}

output "bastion_kubectl_command" {
  description = "kubectl command using the local proxy once the bastion_ssh command is running"
  value       = var.is_private ? "HTTPS_PROXY=localhost:8888 kubectl get pods --all-namespaces" : ""
}
