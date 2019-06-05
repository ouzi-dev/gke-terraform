resource "google_compute_network" "cluster_vpc" {
  name                    = "${var.cluster_name}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "${var.cluster_name}-subnet"
  ip_cidr_range = var.node_cidr_range
  region        = var.region
  network       = google_compute_network.cluster_vpc.self_link

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "${var.cluster_name}-pods"
    ip_cidr_range = var.pod_cidr_range
  }
  secondary_ip_range {
    range_name    = "${var.cluster_name}-services"
    ip_cidr_range = var.service_cidr_range
  }
}

resource "google_compute_firewall" "allow_ssh_workers_from_masters" {
  name      = "${var.cluster_name}-allow-ssh-workers-from-masters"
  network   = google_compute_network.cluster_vpc.name
  direction = "INGRESS"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["443", "6443"]
  }

  source_ranges = [var.master_cidr_range]
}

