variable "region" {
  description = "GKE cluster region"
}
variable "project" {
  description = "Name of the project"
}

variable "zones" {
  description = "GKE Cluster zones"
  type = "list"
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
  type = "list"
  default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_write",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring"
  ]
}

variable "auth_cidr_blocks" {
  type = "list"
  description = "Authorized cidr blocks for the API"
}

variable "kubernetes_version" {
  description = "Minimum k8s master version"
}

variable "machine_type" {
  description = "Instance type for the primary pool of workers"
}

variable "machine_disk_size" {
  description = "Disk size for the primary pool of workers"
}

variable "machine_is_preemptible" {
  description = "If true use preemptible instances"
}

variable "min_nodes" {
  description = "Min number of workers"
  default = 0
}

variable "max_nodes" {
  description = "Max number of workers"
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

variable "init_nodes" {
}

variable "aws_region" {
  description = "AWS region, to create iam roles for external DNS with Route53"
}

variable "main_hosted_zone" {
  description = "Main hosted zone in route 53, terraform will create a new one like: cluster_name.main_hosted_zone"
}

variable "hosted_zone_ttl" {
    description = "TTL for the new hosted zone"
    default = "900"
}

variable "estafette_secret_name" {
  default = "estafette-google-credentials"
}

variable "route53_creds_secret_name" {
  default = "route53-aws-credentials"
}
