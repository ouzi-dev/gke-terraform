resource "google_container_node_pool" "k8s-primary-pool" {
  name       = "${var.cluster_name}-primary-pool"
  location   = "${var.region}"
  cluster    = "${var.gke_cluster_name}"
  node_count = 1

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

    tags = ["${var.cluster_name}"]
  }

  management {
    auto_repair = true
    auto_upgrade = true
  }

#  autoscaling {
#    max_node_count = 3
#    min_node_count = 0
#  }
}