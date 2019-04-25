
provider "google" {
  region      = "${var.region}"
  project     = "${var.project}"
}

provider "google-beta" {
  region      = "${var.region}"
  project     = "${var.project}"
}

#data "google_container_engine_versions" "supported" {
#  location       = "${var.region}"
#  version_prefix = "${var.kubernetes_version}"
#}

module "network" {
  source               = "./modules/network"
  region               = "${var.region}"
  cluster_name         = "${var.cluster_name}"
  node_cidr_range      = "${var.node_cidr_range}"
  pod_cidr_range       = "${var.pod_cidr_range}"
  service_cidr_range   = "${var.service_cidr_range}"
}

module "cluster" {
  source                = "./modules/gke-cluster"
  region                = "${var.region}"
  cluster_name          = "${var.cluster_name}"
  zones                 = "${var.zones}"
  master_cidr_range     = "${var.master_cidr_range}"
  network_name          = "${module.network.network_name}"
  subnet_name           = "${module.network.subnet_name}"
  auth_cidr_blocks      = "${var.auth_cidr_blocks}"
#  master_version    = "${data.google_container_engine_versions.supported.latest_master_version}"
}

module "workers" {
  source                  = "./modules/gke-workers"
  region                  = "${var.region}"
  cluster_name            = "${var.cluster_name}"
  zones                   = "${var.zones}"
  gke_cluster_name        = "${module.cluster.gke_cluster_name}"
  gke_node_scopes         = "${var.gke_node_scopes}"
  machine_type            = "${var.machine_type}"
  machine_disk_size       = "${var.machine_disk_size}"
  machine_is_preemptible  = "${var.machine_is_preemptible}"
}

module "nat" {
  source     = "./modules/nat/nat-gateway"
  region     = "${var.region}"
  tags       = ["${var.cluster_name}"]
  network    = "${module.network.network_name}"
  subnetwork = "${module.network.subnet_name}"
  project    = "${var.project}"
}

output "ip-nat-gateway" {
  value = "${module.nat.external_ip}"
}