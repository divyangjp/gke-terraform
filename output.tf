output "external_ipv4" {
  description = "Global IPv4 address for HTTP(s) load balancing"
  value       = google_compute_global_address.external-ipv4.address
}
