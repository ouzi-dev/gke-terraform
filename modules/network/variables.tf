variable "region" {
}

variable "cluster_name" {
}

variable "node_cidr_range" {
}

variable "pod_cidr_range" {
}

variable "service_cidr_range" {
}

variable "master_cidr_range" {
}

variable "workers_ports_from_master" {
  type = list
  default = ["443", "6443", "8443"]
}