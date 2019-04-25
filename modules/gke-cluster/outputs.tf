output "gke_cluster_name" {
  value = "${google_container_cluster.k8s-cluster.name}"
}
