output "route53_secret_access_key" {
  value = "${aws_iam_access_key.route53_access_key.secret}"
  sensitive = true
}

output "route53_secret_key_id" {
  value = "${aws_iam_access_key.route53_access_key.id}"
  sensitive = true
}

output "ingress_hosted_zone" {
  value = "${aws_route53_zone.ingress_hosted_zone.zone_id}"
}

output "ingress_hosted_zone_name" {
  value = "${var.cluster_name}.${var.main_hosted_zone}"
}
