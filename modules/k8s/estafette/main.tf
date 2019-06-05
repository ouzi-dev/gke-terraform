resource "google_service_account" "estafette_service_account" {
  account_id   = "${var.cluster_name}-estafette"
  display_name = "service account for estafette controllers"
}

resource "google_project_iam_binding" "estafette_compute_engine_admin_role" {
  role = "roles/compute.admin"
  members = [
    "serviceAccount:${google_service_account.estafette_service_account.email}",
  ]
}

resource "google_project_iam_binding" "estafette_kubernetes_engine_admin_role" {
  role = "roles/container.admin"
  members = [
    "serviceAccount:${google_service_account.estafette_service_account.email}",
  ]
}

resource "google_service_account_key" "estafette_key" {
  service_account_id = google_service_account.estafette_service_account.name
}

