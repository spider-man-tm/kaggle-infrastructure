output "static_ip_addresses" {
  description = "Static IP address of the instance"
  value       = google_compute_address.static_ip[*].address
}
