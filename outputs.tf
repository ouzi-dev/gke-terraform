output "estafette_secret_json" {
  value     = module.k8s_bootstrap.estafette_secret_json
  sensitive = true
}