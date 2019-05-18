output "ip-nat-gateway" {
  value = "${module.nat.external_ip}"
}

output "estafette_secret_json" {
  value = "${module.k8s_bootstrap.estafette_secret_json}"
  sensitive = true
}

output "route53_secret_json" {
  value = "${module.k8s_bootstrap.route53_secret_json}"
  sensitive = true
}