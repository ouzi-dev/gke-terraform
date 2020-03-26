variable "region" {
}

variable "zones" {
  type = list(string)
}

variable "cluster_name" {
}

variable "master_version" {
}

variable "master_cidr_range" {
}

variable "network_name" {
}

variable "subnet_name" {
}

variable "auth_cidr_blocks" {
  type = list
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

variable "logging_service" {
  default = "logging.googleapis.com/kubernetes"
}

variable "monitoring_service" {
  default = "monitoring.googleapis.com/kubernetes"
}

variable "authenticator_groups_security_group" {
  type    = string
  default = null
}

variable "enable_private_endpoint" {
  description = "When true, the cluster's private endpoint is used as the cluster endpoint and access through the public endpoint is disabled. When false, either endpoint can be used. This field only applies to private clusters, when enable_private_nodes is true"
  default     = false
}

variable "disable_istio" {
}

variable "istio_config_auth" {
}

variable "cluster_autoscaling" {
  type    = bool
  default = false
}

variable "cluster_autoscaling_profile" {}

variable "cluster_autoscaling_min_cpu" {}

variable "cluster_autoscaling_max_cpu" {}

variable "cluster_autoscaling_min_memory" {}

variable "cluster_autoscaling_max_memory" {}

variable "cluster_autoscaling_gke_scopes" {}