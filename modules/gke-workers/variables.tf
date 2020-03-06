variable "region" {
}

variable "zones" {
  type = list(string)
}

variable "group_name" {
}

variable "gke_cluster_name" {
}

variable "gke_node_scopes" {
  type = list(string)
}

variable "machine_type" {
}

variable "machine_disk_type" {
  default = "pd-standard"
}

variable "machine_disk_size" {
}

variable "machine_is_preemptible" {
}

variable "machine_taints" {
  type    = list(map(string))
  default = []
}

variable "machine_labels" {
  type    = map(string)
  default = {}
}

variable "min_nodes" {
  default = 0
}

variable "max_nodes" {
}

variable "init_nodes" {
}

variable "max_surge" {
}

variable "max_unavailable" {
}