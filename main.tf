
provider "google" {
  region      = "${var.region}"
  project     = "${var.project}"
}

provider "google-beta" {
  region      = "${var.region}"
  project     = "${var.project}"
}

data "google_container_engine_versions" "supported" {
  location       = "${var.region}"
  version_prefix = "${var.kubernetes_version}"
}

module "network" {
  source               = "./modules/network"
  region               = "${var.region}"
  cluster_name         = "${var.cluster_name}"
  node_cidr_range      = "${var.node_cidr_range}"
  pod_cidr_range       = "${var.pod_cidr_range}"
  service_cidr_range   = "${var.service_cidr_range}"
  master_cidr_range    = "${var.master_cidr_range}"
}

module "nat" {
  source     = "./modules/nat/nat-gateway"
  region     = "${var.region}"
  tags       = ["${var.cluster_name}"]
  network    = "${module.network.network_name}"
  subnetwork = "${module.network.subnet_name}"
  project    = "${var.project}"
}

module "cluster" {
  source                      = "./modules/gke-cluster"
  region                      = "${var.region}"
  cluster_name                = "${var.cluster_name}"
  zones                       = "${var.zones}"
  master_cidr_range           = "${var.master_cidr_range}"
  network_name                = "${module.network.network_name}"
  subnet_name                 = "${module.network.subnet_name}"
  auth_cidr_blocks            = "${var.auth_cidr_blocks}"
  master_version              = "${data.google_container_engine_versions.supported.latest_master_version}"
  daily_maintenance           = "${var.daily_maintenance}"
  disable_hpa                 = "${var.disable_hpa}"
  disable_lb                  = "${var.disable_lb}"
  disable_dashboard           = "${var.disable_dashboard}"
  disable_network_policy      = "${var.disable_network_policy}"
  enable_calico               = "${var.enable_calico}"
}

module "default_workers" {
  source                  = "./modules/gke-workers"
  region                  = "${var.region}"
  cluster_name            = "${var.cluster_name}"
  group_name              = "default"
  zones                   = "${var.zones}"
  gke_cluster_name        = "${module.cluster.gke_cluster_name}"
  gke_node_scopes         = "${var.gke_node_scopes}"
  machine_type            = "${var.machine_type}"
  machine_disk_size       = "${var.machine_disk_size}"
  machine_is_preemptible  = "${var.machine_is_preemptible}"
  min_nodes               = "${var.min_nodes}"
  max_nodes               = "${var.max_nodes}"
  init_nodes              = "${var.init_nodes}"
}

module "big_worker" {
  source                  = "./modules/gke-workers"
  region                  = "${var.region}"
  cluster_name            = "${var.cluster_name}"
  group_name              = "n1-s-4"
  zones                   = "${var.zones}"
  gke_cluster_name        = "${module.cluster.gke_cluster_name}"
  gke_node_scopes         = "${var.gke_node_scopes}"
  machine_type            = "n1-standard-4"
  machine_disk_size       = "${var.machine_disk_size}"
  machine_is_preemptible  = "${var.machine_is_preemptible}"
  min_nodes               = "${var.min_nodes}"
  max_nodes               = "${var.max_nodes}"
  init_nodes              = "0"
}

module "estafette" {
  source                  = "./modules/k8s/estafette"
  cluster_name            = "${var.cluster_name}"
  service_account_name    = "${var.estafette_secret_name}"
}

module "route53" {
  source                  = "./modules/k8s/route53"
  aws_region              = "${var.aws_region}"
  cluster_name            = "${var.cluster_name}"
  main_hosted_zone        = "${var.main_hosted_zone}"
  hosted_zone_ttl         = "${var.hosted_zone_ttl}"
}

module "k8s_bootstrap" {
  source                                = "./modules/k8s/bootstrap"
  cluster_endpoint                      = "${module.cluster.endpoint}"
  cluster_ca_certificate                = "${module.cluster.cluster_ca_certificate}"
  cluster_name                          = "${var.cluster_name}"
  region                                = "${var.region}"
  aws_region                            = "${var.aws_region}"
  estafette_secret_name                 = "${var.estafette_secret_name}"
  route53_creds_secret_name             = "${var.route53_creds_secret_name}"
  estafette_google_service_account_b64  = "${module.estafette.google_service_account_b64}"
  route53_secret_access_key             = "${module.route53.route53_secret_access_key}"
  route53_secret_key_id                 = "${module.route53.route53_secret_key_id}"
  ingress_hosted_zone                   = "${module.route53.ingress_hosted_zone}"
  ingress_hosted_zone_name              = "${module.route53.ingress_hosted_zone_name}"
}

