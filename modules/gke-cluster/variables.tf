variable "region" {
}

variable "zones" {
  type = "list"
}

variable "cluster_name" {
}

#variable "master_version" {
#}

variable "master_cidr_range" {
}

variable "network_name" {
}

variable "subnet_name" {
}

variable "auth_cidr_blocks" {
  type = "list"
}
