output "network_name" {
  value = "${google_compute_network.cluster_vpc.name}"
}

output "subnet_name" {
  value = "${google_compute_subnetwork.vpc_subnet.name}"
}
