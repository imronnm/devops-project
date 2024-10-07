# Attach Block Storage
resource "google_compute_attached_disk" "ubuntu_attached_disk" {
  instance = google_compute_instance.ubuntu_instance.name
  disk     = google_compute_disk.ubuntu_disk.name
}

resource "google_compute_attached_disk" "debian_attached_disk" {
  instance = google_compute_instance.debian_instance.name
  disk     = google_compute_disk.debian_disk.name
}
