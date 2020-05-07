resource "google_container_cluster" "k8s-cluster" {
  provider           = google-beta
  name               = var.cluster_name
  description        = "${var.cluster_name} k8s cluster"
  location           = var.region
  node_locations     = var.zones
  network            = var.network_name
  subnetwork         = var.subnet_name
  min_master_version = var.master_version
  enable_legacy_abac = false

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service

  lifecycle {
    ignore_changes = [min_master_version]
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.auth_cidr_blocks
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_cidr_range
    enable_private_endpoint = var.enable_private_endpoint
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "${var.cluster_name}-pods"
    services_secondary_range_name = "${var.cluster_name}-services"
  }

  remove_default_node_pool = true
  initial_node_count       = 1

  dynamic "cluster_autoscaling" {
    for_each = var.cluster_autoscaling?[1,]:[] 
      content {
        enabled             = var.cluster_autoscaling
        autoscaling_profile = var.cluster_autoscaling_profile
        resource_limits {
          resource_type = "cpu"
          minimum       = var.cluster_autoscaling_min_cpu
          maximum       = var.cluster_autoscaling_max_cpu
        }
        resource_limits {
          resource_type = "memory"
          minimum       = var.cluster_autoscaling_min_memory
          maximum       = var.cluster_autoscaling_max_memory
        }
        auto_provisioning_defaults {
          oauth_scopes = var.cluster_autoscaling_gke_scopes
        }
      }
    
  }



  maintenance_policy {
    daily_maintenance_window {
      start_time = var.daily_maintenance
    }
  }

  network_policy {
    enabled = var.enable_calico
  }

  authenticator_groups_config {
    security_group = var.authenticator_groups_security_group
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = var.disable_hpa
    }
    http_load_balancing {
      disabled = var.disable_lb
    }
    network_policy_config {
      disabled = var.disable_network_policy
    }
    istio_config {
      disabled = var.disable_istio
      auth     = var.istio_config_auth
    }
  }
}

