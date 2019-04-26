output "ip-nat-gateway" {
  value = "${module.nat.external_ip}"
}