data "google_client_config" "current" {}

provider "kubernetes" {
  host                   = "${var.cluster_endpoint}"
  cluster_ca_certificate = "${base64decode(var.cluster_ca_certificate)}"
  token                  = "${data.google_client_config.current.access_token}"
  load_config_file       = false
}

resource "kubernetes_namespace" "estafette-namespace" {
  metadata {
    name = "${var.namespace}"
  }
}

resource "google_service_account" "estafette-service-account" {
  account_id   = "estafette"
  display_name = "estafette service account for estafette controllers"
}

resource "google_project_iam_binding" "compute-engine-admin-role" {
  role    = "roles/compute.admin"
  members = [
    "serviceAccount:${google_service_account.estafette-service-account.email}"
  ]
}

resource "google_project_iam_binding" "kubernetes-engine-admin-role" {
  role    = "roles/container.admin"
  members = [
    "serviceAccount:${google_service_account.estafette-service-account.email}"
  ]
}

resource "google_service_account_key" "estafette-key" {
  service_account_id = "${google_service_account.estafette-service-account.name}"
}

resource "kubernetes_secret" "google-application-credentials" {
  metadata = {
    name = "${var.service_account_name}"
    namespace = "${var.namespace}"
  }
  data {
    google-service-account.json = "${base64decode(google_service_account_key.estafette-key.private_key)}"
  }
}