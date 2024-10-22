# Proyek Ansible: Deploy Aplikasi dengan Monitoring dan Reverse Proxy 🚀

Hey, teman-teman! 👋 Selamat datang di proyek Ansible saya. Di sini, kita bakal belajar cara bikin server, install Docker, dan deploy aplikasi dengan fitur-fitur keren! Yuk, kita cek satu per satu.

## Apa sih Ansible itu? 🤔

Ansible itu alat yang bisa membantu kita ngatur banyak server sekaligus, jadi kita gak perlu repot-repot ngelakuin semuanya satu per satu. Ini sangat membantu, terutama kalau kita ngelola server yang banyak!

## Apa yang Kita Lakukan? 🛠️

Di proyek ini, kita bakal ngelakuin beberapa hal seru:
1. **Bikin User Baru**: Kita akan buat akun user baru di server dan login pakai SSH key dan password.
2. **Install Docker**: Kita akan install Docker supaya kita bisa jalanin aplikasi dalam wadah (container).
3. **Deploy Aplikasi Frontend**: Menggunakan Ansible, kita akan deploy aplikasi frontend yang udah kita buat sebelumnya.
4. **Install Monitoring Server**: Kita bakal pasang alat monitoring kayak Node Exporter, Prometheus, dan Grafana.
5. **Setup Reverse Proxy**: Kita akan bikin reverse proxy dengan Nginx supaya traffic aplikasi kita lebih teratur.
6. **Generate SSL Certificate**: Kita bakal bikin sertifikat SSL buat bikin aplikasi kita lebih aman.

## Struktur Folder 📁

Nah, ini dia struktur folder dari proyek kita:

```bash
.
├── ansible.cfg
├── group_vars
│   └── all.yml
├── inventory
│   └── inventory.ini
├── playbooks
│   └── site.yml
└── roles
    ├── create_user
    │   └── tasks
    │       ├── main.yml
    │       └── ssh.yml
    ├── docker
    │   └── tasks
    │       ├── docker_debian.yml
    │       ├── docker_ubuntu.yml
    │       └── main.yml
    ├── frontend
    │   └── tasks
    │       ├── clone.yml
    │       ├── composs.yml
    │       └── main.yml
    ├── monitoring
    │   └── tasks
    │       ├── cardvisor.yml
    │       ├── grafana.yml
    │       ├── main.yml
    │       ├── node_exporter.yml
    │       └── prometheus.yml
    ├── nginx
    │   └── tasks
    │       ├── main.yml
    │       └── nginx.yml
    ├── reverse_proxy
    │   ├── app_server.yml
    │   ├── gateway.yml
    │   ├── main.yml
    │   ├── reverse_debian.yml
    │   └── reverse_ubuntu.yml
    └── ssl
        └── tasks
            └── ssl.yml
```


## Gimana Cara Pakai Proyek Ini? 🚀

1. **Syarat**:
   - Pastikan kamu udah install Ansible di laptop/komputer kamu.
   - Akses ke server yang mau kita kelola.

2. **Jalanin Kode**:
   - Buka terminal di folder proyek ini.
   - Ketik perintah ini untuk mulai:
     ```bash
     ansible-playbook playbooks/site.yml
     ```

3. **Tes Koneksi**:
   - Setelah semua selesai, coba deh connect ke server lewat SSH dengan perintah ini:
     ```bash
     ssh user@<your_server_ip>
     ```
   - Ganti `<your_server_ip>` dengan IP server yang udah kamu buat.

## Kesimpulan 🎉

Dengan Ansible, kita bisa mengautomasi banyak proses yang biasanya makan waktu. Proyek ini adalah langkah awal buat paham cara kerja infrastruktur sebagai kode (Infrastructure as Code - IaC). 