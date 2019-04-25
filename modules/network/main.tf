resource "google_compute_network" "cluster_vpc" {
  name                    = "${var.cluster_name}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "${var.cluster_name}-subnet"
  ip_cidr_range = "${var.node_cidr_range}"
  region        = "${var.region}"
  network       = "${google_compute_network.cluster_vpc.self_link}"

  secondary_ip_range = {
    range_name = "${var.cluster_name}-pods"
    ip_cidr_range = "${var.pod_cidr_range}"
  }

  secondary_ip_range = {
    range_name = "${var.cluster_name}-services"
    ip_cidr_range = "${var.service_cidr_range}"
  }
}