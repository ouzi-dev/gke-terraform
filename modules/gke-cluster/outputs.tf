output "gke_cluster_name" {
  value = google_container_cluster.k8s-cluster.name
}

output "endpoint" {
  value     = google_container_cluster.k8s-cluster.endpoint
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = google_container_cluster.k8s-cluster.master_auth[0].cluster_ca_certificate
  sensitive = true
}

