# Proyek Terraform: Membuat Server dengan Ubuntu dan Debian

Halo, teman-teman! 👋 Selamat datang di proyek Terraform saya. Di sini, saya akan menunjukkan cara membuat dua server dengan sistem operasi yang berbeda—Ubuntu 24 dan Debian 11—dengan beberapa fitur keren! Mari kita lihat lebih dekat.

## Apa itu Terraform? 🤔

Terraform adalah alat yang membantu kita mengelola infrastruktur IT dengan cara yang mudah dan efisien. Dengan Terraform, kita bisa membuat dan mengatur server, jaringan, dan banyak lagi hanya dengan menulis kode. Jadi, kita tidak perlu melakukan semua ini secara manual. Keren, kan?

## Apa yang Kita Buat? 🛠️

Dalam proyek ini, kita akan:
1. **Membuat dua server**: Satu dengan Ubuntu 24 dan satu lagi dengan Debian 11.
2. **Menambahkan VPC (Virtual Private Cloud)** ke dalam server kita untuk mengatur jaringan.
3. **Memberikan IP statis** ke kedua server agar mudah diakses.
4. **Menginstal firewall** di server kita dengan aturan untuk mengizinkan semua IP (0.0.0.0/0).
5. **Membuat dua block storage**: Satu untuk server Ubuntu dan satu untuk server Debian, lalu menghubungkannya ke server yang sesuai.
6. **Menguji koneksi SSH** ke kedua server untuk memastikan semuanya berjalan lancar.

## Struktur Folder 📁

1. Berikut adalah struktur folder dari proyek ini:
```bash
├── attach_blockstorage.tf
├── instance.tf
├── main.tf
├── network.tf
├── providers.tf
├── static_ip.tf
└── vars.tf
```


## Cara Menggunakan Proyek Ini 🚀

1. **Persyaratan**:
   - Pastikan kamu sudah menginstal Terraform di komputermu.
   - Akses ke penyedia layanan cloud (seperti AWS, GCP, atau DigitalOcean).

2. **Menjalankan Kode**:
   - Buka terminal di folder proyek ini.
   - Jalankan perintah berikut untuk memulai:
     ```bash
     terraform init  # Menginisialisasi proyek Terraform
     terraform plan  # Melihat rencana sebelum menerapkan
     terraform apply # Menerapkan perubahan dan membuat server
     ```

3. **Tes Koneksi**:
   - Setelah server selesai dibuat, coba hubungkan ke server menggunakan SSH dengan perintah:
     ```bash
     ssh user@<static_ip>
     ```
   - Gantilah `<static_ip>` dengan IP statis yang telah diberikan.

## Kesimpulan 🎉

Dengan menggunakan Terraform, kita dapat dengan mudah membuat dan mengelola infrastruktur cloud kita. Proyek ini adalah langkah awal yang baik untuk memahami cara kerja infrastruktur sebagai kode (Infrastructure as Code - IaC).
