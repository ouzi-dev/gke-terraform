resource "google_container_node_pool" "k8s-worker-pool" {
  provider           = google-beta
  name               = "${var.gke_cluster_name}-${var.group_name}"
  location           = var.region
  cluster            = var.gke_cluster_name
  initial_node_count = var.init_nodes

  lifecycle {
    ignore_changes = [
      node_count,
      initial_node_count,
    ]
    create_before_destroy = true
  }

  node_config {
    preemptible  = var.machine_is_preemptible
    machine_type = var.machine_type
    disk_type    = var.machine_disk_type
    disk_size_gb = var.machine_disk_size
    oauth_scopes = var.gke_node_scopes

    metadata = {
      disable-legacy-endpoints = "true"
    }

    dynamic "taint" {
      for_each = var.machine_taints
      iterator = item
      content {
        effect = item.value.effect
        key    = item.value.key
        value  = item.value.value
      }
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    max_node_count = var.max_nodes
    min_node_count = var.min_nodes
  }
}

