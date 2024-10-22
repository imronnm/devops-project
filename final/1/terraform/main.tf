provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.regions[0]
  zone        = var.zones[0]
}

# Appserver di Jakarta (2 vCPU)
resource "google_compute_instance" "appserver" {
  name         = "appserver"
  machine_type = "e2-medium"
  zone         = var.zones[0]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_key_path)}"
  }

  tags = ["allow-appserver"]
}

# Firewall untuk Appserver - Membuka port 3000, 5000, dan MySQL
resource "google_compute_firewall" "allow_appserver" {
  name    = "allow-appserver"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["3000", "5000", "3306"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["allow-appserver"]
}

# Gateway di Singapore (1 vCPU, buka hanya port 22)
resource "google_compute_instance" "gateway" {
  name         = "gateway"
  machine_type = "e2-micro"
  zone         = var.zones[1]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_key_path)}"
  }

  tags = ["allow-ssh"]
}

# Firewall untuk Gateway - Membuka hanya port 22
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["allow-ssh"]
}

# Jenkins dan SonarQube di Singapore (2 vCPU)
resource "google_compute_instance" "jenkins_sonarqube" {
  name         = "jenkins-sonarqube"
  machine_type = "e2-medium"
  zone         = var.zones[1]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_key_path)}"
  }

  tags = ["allow-jenkins-sonarqube"]
}

# Monitoring Server di Jakarta (1 vCPU)
resource "google_compute_instance" "monitoring_server" {
  name         = "monitoring-server"
  machine_type = "e2-micro"
  zone         = var.zones[0]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_key_path)}"
  }

  tags = ["allow-monitoring"]
}

# Web Server NGINX di Jakarta (2 vCPU)
resource "google_compute_instance" "nginx_webserver" {
  name         = "nginx-webserver"
  machine_type = "e2-medium"
  zone         = var.zones[0]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_key_path)}"
  }

  tags = ["allow-http"]
}

# Firewall untuk Web Server NGINX - Membuka port HTTP dan HTTPS
resource "google_compute_firewall" "allow_http_https" {
  name    = "allow-http-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["allow-http"]
}

# Docker Registry Private di Jakarta (2 vCPU)
resource "google_compute_instance" "docker_registry" {
  name         = "docker-registry"
  machine_type = "e2-medium"
  zone         = var.zones[0]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_key_path)}"
  }

  tags = ["allow-docker"]
}

# Firewall untuk Docker Registry - Membuka port Docker Registry (port 5000)
resource "google_compute_firewall" "allow_docker_registry" {
  name    = "allow-docker-registry"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["5000"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["allow-docker"]
}

# K3s Master Node di Taiwan (2 vCPU)
resource "google_compute_instance" "k3s_master" {
  name         = "k3s-master"
  machine_type = "e2-medium"
  zone         = var.k3s_master_zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_key_path)}"
  }

  tags = ["allow-k3s-master"]
}

# K3s Worker Node 1 di Taiwan (1 vCPU)
resource "google_compute_instance" "k3s_worker_1" {
  name         = "k3s-worker-1"
  machine_type = "e2-medium"
  zone         = var.k3s_worker_zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_key_path)}"
  }

  tags = ["allow-k3s-worker"]
}

# Firewall untuk K3s Master dan Worker Nodes - Membuka port 3000, 5000, dan PostgreSQL
resource "google_compute_firewall" "allow_k3s" {
  name    = "allow-k3s"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["3000", "5000", "5432"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["allow-k3s-master", "allow-k3s-worker"]
}
