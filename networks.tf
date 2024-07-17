data "google_compute_network" "this" {
  project = var.project_id
  name    = var.network_name
}

data "google_compute_subnetwork" "this" {
  project = var.project_id
  name    = var.subnet_name
  region  = var.region
}
