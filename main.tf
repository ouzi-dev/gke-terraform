module "network" {
  source                    = "./modules/network"
  region                    = var.region
  cluster_name              = var.cluster_name
  node_cidr_range           = var.node_cidr_range
  pod_cidr_range            = var.pod_cidr_range
  service_cidr_range        = var.service_cidr_range
  master_cidr_range         = var.master_cidr_range
  workers_ports_from_master = var.network_allow_workers_ports_from_master
}

module "cluster" {
  source                              = "./modules/gke-cluster"
  region                              = var.region
  cluster_name                        = var.cluster_name
  zones                               = var.zones
  master_cidr_range                   = var.master_cidr_range
  network_name                        = module.network.network_name
  subnet_name                         = module.network.subnet_name
  auth_cidr_blocks                    = var.auth_cidr_blocks
  master_version                      = var.kubernetes_version
  daily_maintenance                   = var.daily_maintenance
  disable_hpa                         = var.disable_hpa
  disable_lb                          = var.disable_lb
  disable_dashboard                   = var.disable_dashboard
  disable_network_policy              = var.disable_network_policy
  authenticator_groups_security_group = var.authenticator_groups_security_group
  enable_calico                       = var.enable_calico
  logging_service                     = var.logging_service
  monitoring_service                  = var.monitoring_service
  disable_istio                       = var.disable_istio
  istio_config_auth                   = var.istio_config_auth
  cluster_autoscaling                 = var.cluster_autoscaling
  cluster_autoscaling_profile         = var.cluster_autoscaling_profile
  cluster_autoscaling_min_cpu         = var.cluster_autoscaling_min_cpu
  cluster_autoscaling_max_cpu         = var.cluster_autoscaling_max_cpu
  cluster_autoscaling_min_memory      = var.cluster_autoscaling_min_memory
  cluster_autoscaling_max_memory      = var.cluster_autoscaling_max_memory
  cluster_autoscaling_gke_scopes      = var.gke_node_scopes
}

module "default_workers" {
  source = "./modules/gke-workers"

  region                 = var.region
  group_name             = "default"
  zones                  = var.zones
  gke_cluster_name       = module.cluster.gke_cluster_name
  gke_node_scopes        = var.gke_node_scopes
  machine_type           = var.machine_type
  machine_disk_size      = var.machine_disk_size
  machine_disk_type      = var.machine_disk_type
  machine_is_preemptible = var.machine_is_preemptible
  min_nodes              = var.min_nodes
  max_nodes              = var.max_nodes
  init_nodes             = var.init_nodes
  max_surge              = var.max_surge
  max_unavailable        = var.max_unavailable
}