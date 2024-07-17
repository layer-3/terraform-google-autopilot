locals {
  bastion_name = "gke-${var.name}-bastion"
  bastion_zone = var.bastion_zone != null ? var.bastion_zone : "${var.region}-a"
}

module "bastion" {
  count  = var.is_private ? 1 : 0
  source = "terraform-google-modules/bastion-host/google"

  name           = local.bastion_name
  project        = var.project_id
  region         = var.region
  zone           = local.bastion_zone
  network        = data.google_compute_network.this.self_link
  subnet         = data.google_compute_subnetwork.this.self_link
  image_project  = "debian-cloud"
  machine_type   = "g1-small"
  members        = var.bastion_members
  shielded_vm    = "false"
  startup_script = <<-EOF
  #! /bin/bash
  apt-get update
  apt-get install -y tinyproxy
  grep -qxF 'Allow localhost' /etc/tinyproxy/tinyproxy.conf || echo 'Allow localhost' >> /etc/tinyproxy/tinyproxy.conf
  service tinyproxy restart
  EOF

  disk_size_gb               = 10
  fw_name_allow_ssh_from_iap = "${local.bastion_name}-allow-ssh-from-iap"
  service_account_name       = "${local.bastion_name}-sa"
}
