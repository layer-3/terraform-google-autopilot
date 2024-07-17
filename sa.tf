locals {
  service_account_name = "gke-${var.name}-agent-sa"
  service_account_roles = [
    "roles/container.defaultNodeServiceAccount",
    "roles/monitoring.metricWriter",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/storage.objectViewer",
    "roles/artifactregistry.reader",
  ]
}

resource "google_service_account" "cluster_sa" {
  project      = var.project_id
  account_id   = local.service_account_name
  display_name = "Terraform-managed service account for cluster ${var.name}"
}

resource "google_project_iam_member" "cluster_sa_role_bindings" {
  count   = length(local.service_account_roles)
  project = google_service_account.cluster_sa.project
  role    = local.service_account_roles[count.index]
  member  = google_service_account.cluster_sa.member
}
