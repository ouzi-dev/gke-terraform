variable "region" {
}

variable "zones" {
  type = "list"
}

variable "cluster_name" {
}

variable "gke_cluster_name" {
}

variable "gke_node_scopes" {
  type = "list"
}

variable "machine_type" {
}

variable "machine_disk_size" {
}

variable "machine_is_preemptible" {
}