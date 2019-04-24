
provider "google" {
  region      = "${var.region}"
  project     = "${var.project}"
}

resource "google_compute_network" "cluster_vpc" {
  name                    = "${var.cluster_name}-vpc"
  auto_create_subnetworks = false
  project                 = "${var.project}"
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

data "google_container_engine_versions" "supported" {
  location       = "${var.region}"
  version_prefix = "${var.kubernetes_version}"
}

resource "google_container_cluster" "k8s-cluster" {
  depends_on = ["google_compute_subnetwork.vpc_subnet"]
  name               = "${var.cluster_name}"
  description        = "${var.cluster_name} k8s cluster"
  location           = "${var.region}"
  node_locations     = ["${var.zones}"]
  network            = "${google_compute_network.cluster_vpc.name}"
  subnetwork         = "${google_compute_subnetwork.vpc_subnet.name}"
  min_master_version = "${data.google_container_engine_versions.supported.latest_master_version}"
  enable_legacy_abac = false

#  master_authorized_networks_config {
#    cidr_blocks = ["${var.auth_cidr_blocks}"]
#  } 

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes = true
    master_ipv4_cidr_block = "${var.master_cidr_range}"
  }

  ip_allocation_policy {
    cluster_secondary_range_name = "${var.cluster_name}-pods"
    services_secondary_range_name = "${var.cluster_name}-services"
  }

  remove_default_node_pool = true
  initial_node_count = 1

  maintenance_policy {
    daily_maintenance_window {
      start_time = "02:00"
    }
  }

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = ""
    password = ""
  }

  network_policy {
    enabled = false
    provider = "CALICO"
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }
    http_load_balancing {
      disabled = false
    }
    kubernetes_dashboard  {
      disabled = false
    }
    network_policy_config {
      disabled = true
    }
  }

#  cluster_autoscaling {
#    enabled = true
#  }
}

resource "google_container_node_pool" "k8s-primary-pool" {
  name       = "${var.cluster_name}-primary-pool"
  location   = "${var.region}"
  cluster    = "${google_container_cluster.k8s-cluster.name}"
  node_count = 1
  version    = "${data.google_container_engine_versions.supported.latest_node_version}"

  lifecycle {
    ignore_changes = ["node_count"]
  }

  node_config {
    preemptible  = "${var.machine_is_preemptible}"
    machine_type = "${var.machine_type}"
    disk_size_gb = "${var.machine_disk_size}"
    oauth_scopes = "${var.gke_node_scopes}"

    metadata {
      disable-legacy-endpoints = "true"
    }

  }

  management {
    auto_repair = true
#    auto_upgrade = true
  }

#  autoscaling {
#    max_node_count = 3
#    min_node_count = 0
#  }
}

# The following outputs allow authentication and connectivity to the GKE Cluster
# by using certificate-based authentication.
#
# Output for K8S
#
data "template_file" "kubeconfig" {
  template = "${file("${path.module}/kubeconfig-template.yaml")}"

  vars {
    cluster_name    = "${google_container_cluster.k8s-cluster.name}"
    endpoint        = "${google_container_cluster.k8s-cluster.endpoint}"
    cluster_ca      = "${google_container_cluster.k8s-cluster.master_auth.0.cluster_ca_certificate}"
    client_cert     = "${google_container_cluster.k8s-cluster.master_auth.0.client_certificate}"
    client_cert_key = "${google_container_cluster.k8s-cluster.master_auth.0.client_key}"
  }
}

resource "local_file" "kubeconfig" {
  content  = "${data.template_file.kubeconfig.rendered}"
  filename = "${path.module}/kubeconfig"
}
