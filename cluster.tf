locals {
  cluster_network_tag = "gke-${var.name}"
}

resource "google_container_cluster" "this" {
  name        = var.name
  description = var.description
  project     = var.project_id

  location   = var.region
  network    = data.google_compute_network.this.id
  subnetwork = data.google_compute_subnetwork.this.id

  enable_autopilot = true

  release_channel {
    channel = var.release_channel
  }

  cost_management_config {
    enabled = true
  }

  cluster_autoscaling {
    auto_provisioning_defaults {
      service_account = google_service_account.cluster_sa.email
    }
  }

  vertical_pod_autoscaling {
    enabled = true
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.is_private ? [
        {
          display_name = "Bastion Host"
          cidr_block   = "${module.bastion[0].ip_address}/32"
        }
        ] : [
        {
          display_name = "allow all"
          cidr_block   = "0.0.0.0/0"
        }
      ]

      content {
        display_name = cidr_blocks.value.display_name
        cidr_block   = cidr_blocks.value.cidr_block
      }
    }
  }

  node_pool_auto_config {
    network_tags {
      tags = concat(var.network_tags, [local.cluster_network_tag])
    }
  }

  logging_config {
    enable_components = var.logging_components
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }

    gcs_fuse_csi_driver_config {
      enabled = true
    }
  }

  dynamic "fleet" {
    for_each = var.fleet_project != null ? [1] : []
    content {
      project = var.fleet_project
    }
  }

  dynamic "private_cluster_config" {
    for_each = var.is_private ? [1] : []

    content {
      enable_private_nodes    = true
      enable_private_endpoint = true
      master_global_access_config {
        enabled = false
      }
    }
  }

  deletion_protection = var.deletion_protection

  depends_on = [
    google_project_iam_member.cluster_sa_role_bindings,
    module.bastion
  ]
}
