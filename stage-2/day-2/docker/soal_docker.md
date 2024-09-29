# DevOps 21 - Dumbways Project

Selamat datang di repositori **devops20-dumbways-<nama_kalian>**! Dalam proyek ini, kami akan melakukan langkah-langkah untuk mengimplementasikan aplikasi web menggunakan Docker. Berikut adalah panduan lengkap untuk menyelesaikan tugas ini.

## Persyaratan Sebelum Memulai

1. **Akun GitHub**: Pastikan Anda memiliki akun GitHub dan buat repositori dengan judul `devops20-dumbways-<nama_kalian>`.
2. **File README.md**: Gunakan file ini untuk mendokumentasikan semua langkah pengerjaan tugas Anda.
3. **Diskusi**: Diskusikan dengan tim Anda tentang VM (Virtual Machine) yang akan digunakan untuk menjalankan aplikasi ini.

## Repository dan Referensi

- [Wayshub Backend](URL_BACKEND)
- [Wayshub Frontend](URL_FRONTEND)
- [Certbot](URL_CERBOT)
- [PM2 Runtime With Docker](URL_PM2)

## Tugas

### 1. Membuat User Baru

Buat user baru di VM dengan nama tim Anda.

### 2. Instalasi Docker

Buatlah skrip bash yang dapat melakukan instalasi Docker secara otomatis. Skrip ini bisa dibuat semenarik mungkin.

### 3. Deploy Aplikasi dengan Docker Compose

#### Ketentuan Umum

- Buatlah dua lingkungan (environment): **staging** dan **production**.

#### A. Lingkungan Staging

- Buat file `docker-compose.yml` yang berisi beberapa layanan:
  - Web Server
  - Frontend
  - Backend
  - Database
  
- Penamaan image:
  - Gunakan format: `team1/dumbflx/frontend:staging`.
  
- Buat custom network dengan nama tim Anda dan hubungkan semua service ke dalamnya.

- Deploy database menggunakan MySQL dan pastikan untuk menggunakan volume agar data tetap tersimpan.

#### B. Lingkungan Production

- Deploy database di server terpisah.
- Buat server backend terpisah dengan 2 container.
- Buat server frontend terpisah dengan 2 container.
- Web Server juga harus terpisah untuk konfigurasi reverse proxy.

- Penamaan image:
  - Gunakan format: `team1/dumbflx/frontend:production`.

### 4. Membangun Image

- Usahakan untuk membangun image frontend dan backend dengan ukuran sekecil mungkin (gunakan multistage build).
- Pastikan untuk menyesuaikan konfigurasi backend dengan database dan frontend dengan backend sebelum membangun menjadi docker images.

### 5. Konfigurasi Reverse Proxy

- Buat konfigurasi reverse-proxy menggunakan Nginx di Docker.
- **Catatan**: SSL menggunakan Cloudflare dimatikan dan gunakan wildcard untuk SSL.
- Gunakan volume Docker untuk konfigurasi reverse proxy.

#### Contoh DNS

- **Staging**
  - Frontend: `team1.staging.studentdumbways.my.id`
  - Backend: `api.team1.staging.studentdumbways.my.id`
  
- **Production**
  - Frontend: `team1.studentdumbways.my.id`
  - Backend: `api.team1.studentdumbways.my.id`

### 6. Push Image

- Push image yang telah dibuat ke Docker registry masing-masing.

### 7. Pengujian Aplikasi

Pastikan aplikasi dapat berjalan dengan baik, termasuk fitur login dan registrasi.

## Kesimpulan