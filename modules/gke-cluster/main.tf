resource "google_container_cluster" "k8s-cluster" {
  name               = "${var.cluster_name}"
  description        = "${var.cluster_name} k8s cluster"
  location           = "${var.region}"
  node_locations     = ["${var.zones}"]
  network            = "${var.network_name}"
  subnetwork         = "${var.subnet_name}"
  min_master_version = "${var.master_version}"
  enable_legacy_abac = false

  master_authorized_networks_config = {
    cidr_blocks = ["${var.auth_cidr_blocks}"]
  }

  private_cluster_config {
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