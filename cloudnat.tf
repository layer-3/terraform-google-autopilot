locals {
  default_router_name = "gke-${var.name}-cloud-nat"
  router_name         = var.deploy_nat ? google_compute_router.this[0].name : var.router_name
}

resource "google_compute_router" "this" {
  count = var.deploy_nat ? 1 : 0

  name    = var.router_name != "" ? var.router_name : local.default_router_name
  project = var.project_id
  region  = var.region
  network = data.google_compute_network.this.id
}

resource "google_compute_router_nat" "this" {
  count = var.deploy_nat ? 1 : 0

  project                            = var.project_id
  region                             = var.region
  name                               = local.router_name
  router                             = local.router_name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
