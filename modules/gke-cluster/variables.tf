variable "region" {
}

variable "zones" {
  type = "list"
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
  type = "list"
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
