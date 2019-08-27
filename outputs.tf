output "estafette_secret_json" {
  value     = module.k8s_bootstrap.estafette_secret_json
  sensitive = true
}


output "cluster_endpoint" {
  value     = module.cluster.endpoint
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = module.cluster.cluster_ca_certificate
  sensitive = true
}

