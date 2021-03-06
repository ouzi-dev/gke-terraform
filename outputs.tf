output "cluster_endpoint" {
  value     = module.cluster.endpoint
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = module.cluster.cluster_ca_certificate
  sensitive = true
}

output "cluster_network_name" {
  value = module.network.network_name
}
