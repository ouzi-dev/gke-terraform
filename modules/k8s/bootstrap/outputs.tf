output "estafette_secret_json" {
  value = "${local.estaffete_secret_json}"
  sensitive = true
}

output "route53_secret_json" {
  value = "${local.route53_secret_json}"
  sensitive = true
}
