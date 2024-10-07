# Static IPs
resource "google_compute_address" "static_ip_ubuntu" {
  name   = "static-ip-ubuntu"
  region = var.region
}

resource "google_compute_address" "static_ip_debian" {
  name   = "static-ip-debian"
  region = var.region
}
