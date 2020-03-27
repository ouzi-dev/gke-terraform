# gke-terraform

A GKE Terraform module that creates a GKE cluster with various options.

## Features

* zonal or regional 
* master, node and service CIDR range
* node Scopes
* authorized cidr blocks for the API
* kubernetes version 
* GKE features can be turned on or off 
  * HPA
  * LB
  * Dashboard
  * Network Policies
  * Calico
  * Logging Service
  * Monitoring Service
  * Istio
  * NodeGroup Auto Provisioning - allows GKE to auto provision Node Groups and autoscale them without having to specify node groups at all 
* optional NodeGroups
  * support autoscaling within the node group

## How to Use

### With Cluster NodeGroup AutoProvisioning

```
data "google_compute_zones" "available" {}

## Modules
module "gke-cluster" {
  source = "github.com/ouzi-dev/gke-terraform.git?ref=v0.9.0"
  region  = var.gcloud_region
  project = var.gcloud_project

  cluster_name = var.gke_name
  zones = slice(data.google_compute_zones.available.names, 0, var.gke_num_of_zones)

  node_cidr_range    = var.gke_node_cidr_range
  pod_cidr_range     = var.gke_pod_cidr_range
  service_cidr_range = var.gke_service_cidr_range
  master_cidr_range  = var.gke_master_cidr_range
  gke_node_scopes    = var.gke_node_scopes
  auth_cidr_blocks   = var.gke_auth_cidr_blocks
  kubernetes_version = var.gke_kubernetes_version

  cluster_autoscaling = var.cluster_autoscaling
  cluster_autoscaling_min_cpu = var.cluster_autoscaling_min_cpu
  cluster_autoscaling_max_cpu = var.cluster_autoscaling_max_cpu
  cluster_autoscaling_min_memory = var.cluster_autoscaling_min_memory
  cluster_autoscaling_max_memory = var.cluster_autoscaling_max_memory

  daily_maintenance                   = var.gke_daily_maintenance
  disable_hpa                         = var.gke_disable_hpa
  disable_lb                          = var.gke_disable_lb
  disable_dashboard                   = var.gke_disable_dashboard
  disable_network_policy              = var.gke_disable_network_policy
  disable_istio                       = var.gke_disable_istio
  enable_calico                       = var.gke_enable_calico
  authenticator_groups_security_group = var.gke_authenticator_groups_security_group
  init_nodes                          = var.gke_init_nodes

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service
}
``` 
### Without Cluster NodeGroup AutoProvisioning

```
data "google_compute_zones" "available" {}

module "gke-cluster" {
  source = "github.com/ouzi-dev/gke-terraform.git?ref=v0.9.0"
  region  = var.gcloud_region
  project = var.gcloud_project

  cluster_name = var.gke_name
  zones = slice(data.google_compute_zones.available.names, 0, var.gke_num_of_zones)

  node_cidr_range    = var.gke_node_cidr_range
  pod_cidr_range     = var.gke_pod_cidr_range
  service_cidr_range = var.gke_service_cidr_range
  master_cidr_range  = var.gke_master_cidr_range
  gke_node_scopes    = var.gke_node_scopes
  auth_cidr_blocks   = var.gke_auth_cidr_blocks
  kubernetes_version = var.gke_kubernetes_version

  machine_type           = var.gke_machine_type
  machine_disk_size      = var.gke_machine_disk_size
  machine_is_preemptible = var.gke_machine_is_preemptible
  min_nodes              = var.gke_min_nodes
  max_nodes              = var.gke_max_nodes
  max_surge              = var.max_surge
  max_unavailable        = var.max_unavailable

  daily_maintenance                   = var.gke_daily_maintenance
  disable_hpa                         = var.gke_disable_hpa
  disable_lb                          = var.gke_disable_lb
  disable_dashboard                   = var.gke_disable_dashboard
  disable_network_policy              = var.gke_disable_network_policy
  disable_istio                       = var.gke_disable_istio
  enable_calico                       = var.gke_enable_calico
  authenticator_groups_security_group = var.gke_authenticator_groups_security_group
  init_nodes                          = var.gke_init_nodes

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service
}
```