variable "region" {
  description = "GKE cluster region"
}

variable "project" {
  description = "Name of the project"
}

variable "zones" {
  description = "GKE Cluster zones"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
}

# See: https://cloud.google.com/kubernetes-engine/docs/how-to/ip-aliases
variable "node_cidr_range" {
  description = "VPC nodes CIDR range"
}

variable "pod_cidr_range" {
  description = "VPC pods CIDR range"
}

variable "service_cidr_range" {
  description = "VPC services CIDR range"
}

variable "master_cidr_range" {
  description = "CIDR range for masters"
}

variable "gke_node_scopes" {
  description = "The GKE node scopes"
  type        = list(string)
  default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_write",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
  ]
}

variable "auth_cidr_blocks" {
  type        = list
  description = "Authorized cidr blocks for the API"
}

variable "kubernetes_version" {
  description = "Minimum k8s master version"
}

variable "machine_type" {
  description = "Instance type for the primary pool of workers"
  default     = "n2-standard-4"
}

variable "machine_disk_size" {
  description = "Disk size for the primary pool of workers"
  default     = 50
}

variable "machine_disk_type" {
  description = "Disk type for the primary pool of workers"
  default     = "pd-standard"
}

variable "machine_is_preemptible" {
  description = "If true use preemptible instances"
  default     = true
}

variable "min_nodes" {
  description = "Min number of workers"
  default     = 0
}

variable "max_nodes" {
  description = "Max number of workers"
  default     = 4
}

variable "max_surge" {
  default = 1
}

variable "max_unavailable" {
  default = 0
}

variable "daily_maintenance" {
  default = "02:00"
}

variable "disable_hpa" {
  default = false
}

variable "disable_lb" {
  default = false
}

variable "disable_dashboard" {
  default = false
}

variable "disable_network_policy" {
  default = false
}

variable "enable_calico" {
  default = true
}

variable "network_allow_workers_ports_from_master" {
  type    = list
  default = ["443", "6443", "8443"]
}

variable "init_nodes" {
}

variable "authenticator_groups_security_group" {
  type    = string
  default = null
}

variable "logging_service" {
  default = "logging.googleapis.com/kubernetes"
}

variable "monitoring_service" {
  default = "monitoring.googleapis.com/kubernetes"
}

variable "disable_istio" {
  default = true
}

variable "istio_config_auth" {
  default = "AUTH_MUTUAL_TLS"
}

variable "cluster_autoscaling" {
  default = true
}

variable "cluster_autoscaling_profile" {
  default = "OPTIMIZE_UTILIZATION"
}

variable "cluster_autoscaling_min_cpu" {
  default = 2
}

variable "cluster_autoscaling_max_cpu" {
  default = 12
}

variable "cluster_autoscaling_min_memory" {
  default = 8
}

variable "cluster_autoscaling_max_memory" {
  default = 48
}
