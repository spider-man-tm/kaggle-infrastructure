# Create static ip for the instance
resource "google_compute_address" "static_ip" {
  count        = var.instance_count
  name         = "${var.static_ip_name}-${count.index}"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
  region       = var.region
}
