output "tunnel0" {
  value = google_compute_vpn_tunnel.tunnel0
}

output "tunnel1" {
  value = google_compute_vpn_tunnel.tunnel1
}

output "cluster" {
  value = var.cluster_name
}