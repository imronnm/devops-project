# Dokumentasi Setup Monitoring menggunakan Docker

Dokumentasi ini menjelaskan cara mengimplementasikan sistem monitoring menggunakan Node Exporter dan cAdvisor dengan Docker di lingkungan GCP.

## Prasyarat

- Akun Google Cloud Platform (GCP)
- Terraform sudah terinstall
- Ansible sudah terinstall
- Docker sudah terinstall di local machine
- SSH key untuk akses ke VM


## Langkah 1: Setup Infrastructure dengan Terraform

### Konfigurasi VM

Tambahkan konfigurasi berikut di file Terraform untuk setiap VM:

```hcl
network_interface {
  network = "default"
  access_config {
    nat_ip = google_compute_address.static_ip.address
  }
}

metadata = {
  ssh-keys = "${var.ssh_user}:${file(var.ssh_key_path)}"
}
```

### Jalankan Terraform

```bash
terraform init
terraform apply
```

## Langkah 2: Konfigurasi Ansible

### Setup Inventory

Buat file `ansible/hosts`:

```ini
[monitoring_servers]
server1 ansible_host=<IP_SERVER1> ansible_user=ubuntu
server2 ansible_host=<IP_SERVER2> ansible_user=ubuntu
```

### Buat Docker Compose

Buat file `ansible/files/docker-compose.yml`:

```yaml
version: '3'

services:
  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: unless-stopped
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    ports:
      - "9100:9100"
    network_mode: host

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: cadvisor
    restart: unless-stopped
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /dev/disk/:/dev/disk:ro
    ports:
      - "8080:8080"
    privileged: true
```

### Buat Playbook Ansible

Buat file `ansible/playbook.yml`:

```yaml
---
- name: Setup Monitoring Stack
  hosts: monitoring_servers
  become: yes
  tasks:
    - name: Install Docker dan Docker Compose
      apt:
        name:
          - docker.io
          - docker-compose
        state: present
        update_cache: yes

    - name: Pastikan Docker berjalan
      service:
        name: docker
        state: started
        enabled: yes

    - name: Buat direktori monitoring
      file:
        path: /opt/monitoring
        state: directory

    - name: Copy docker-compose file
      copy:
        src: files/docker-compose.yml
        dest: /opt/monitoring/docker-compose.yml

    - name: Jalankan monitoring stack
      docker_compose:
        project_src: /opt/monitoring
        state: present
```

## Langkah 3: Deployment

### Jalankan Ansible Playbook

```bash
ansible-playbook -i hosts playbook.yml
```

## Verifikasi Instalasi

### 1. Cek Status Container

```bash
docker ps
```

### 2. Akses Metrics

- Node Exporter: `http://<IP-SERVER>:9100/metrics`
- cAdvisor: `http://<IP-SERVER>:8080`

### 3. Cek Logs Container

```bash
# Untuk Node Exporter
docker logs node-exporter

# Untuk cAdvisor
docker logs cadvisor
```

## Port yang Digunakan

- Node Exporter: 9100
- cAdvisor: 8080

## Troubleshooting

### 1. Container Tidak Berjalan

```bash
# Cek status container
docker ps -a

# Cek logs
docker logs node-exporter
docker logs cadvisor

# Restart container
docker restart node-exporter
docker restart cadvisor
```

### 2. Masalah Akses Metrics

- Pastikan port sudah terbuka di firewall GCP
- Cek status container dan logs
- Verifikasi konfigurasi network di docker-compose

### 3. Masalah Resource

```bash
# Cek penggunaan resource
docker stats
```

## Maintenance

### Backup Konfigurasi

```bash
# Backup docker-compose
cp /opt/monitoring/docker-compose.yml /backup/

# Backup data metrics (jika ada)
tar -czf /backup/metrics-$(date +%Y%m%d).tar.gz /opt/monitoring/data
```

### Update Container

```bash
# Pull image terbaru
docker pull prom/node-exporter:latest
docker pull gcr.io/cadvisor/cadvisor:latest

# Restart container
cd /opt/monitoring
docker-compose down
docker-compose up -d
```

## Catatan Penting

- Selalu backup konfigurasi sebelum melakukan update
- Monitor penggunaan resource secara berkala
- Update image container secara regular untuk keamanan
- Pastikan firewall mengizinkan akses ke port yang diperlukan
- Gunakan authentication jika exposed ke public

## Bantuan

Jika mengalami masalah, bisa:
1. Cek logs container
2. Verifikasi konfigurasi docker-compose
3. Pastikan semua volume yang diperlukan tersedia
4. Periksa koneksi network

## Referensi

- [Node Exporter Documentation](https://github.com/prometheus/node_exporter)
- [cAdvisor Documentation](https://github.com/google/cadvisor)
- [Docker Documentation](https://docs.docker.com/)