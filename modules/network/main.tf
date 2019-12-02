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

resource "google_compute_firewall" "allow_workers_from_master" {
  name      = "${var.cluster_name}-allow-workers-from-master"
  network   = google_compute_network.cluster_vpc.name
  direction = "INGRESS"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = var.workers_ports_from_master
  }

  source_ranges = [var.master_cidr_range]
}

resource "google_compute_router" "router" {
  name    = "router"
  region  = google_compute_subnetwork.vpc_subnet.region
  network = google_compute_network.cluster_vpc.self_link
  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "simple-nat" {
  name                               = "nat-1"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}