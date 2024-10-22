# VM Ubuntu
resource "google_compute_instance" "ubuntu_instance" {
  name         = "ubuntu-instance"
  machine_type = "e2-medium"  # sesuaikan dengan kebutuhan
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"  # gambar Ubuntu 22.04
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnetwork.name
    access_config {
      nat_ip = google_compute_address.static_ip_ubuntu.address
    }
  }

  metadata = {
    ssh-keys = "imron:${file("~/.ssh/id_rsa.pub")}"
  }
}

# VM Debian
resource "google_compute_instance" "debian_instance" {
  name         = "debian-instance"
  machine_type = "e2-medium"  # sesuaikan dengan kebutuhan
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"  # gambar Debian 11
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnetwork.name
    access_config {
      nat_ip = google_compute_address.static_ip_debian.address
    }
  }

  metadata = {
    ssh-keys = "imron:${file("~/.ssh/id_rsa.pub")}"
  }
}

# Block Storage
resource "google_compute_disk" "ubuntu_disk" {
  name  = "ubuntu-disk"
  type  = "pd-standard"
  zone  = var.zone
  size  = 20  # ukuran dalam GB
}

resource "google_compute_disk" "debian_disk" {
  name  = "debian-disk"
  type  = "pd-standard"
  zone  = var.zone
  size  = 20  # ukuran dalam GB
}