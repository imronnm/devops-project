# Perbedaan Shell Script dan Bash Script

## Pengertian
- **Shell Script**: Kode perintah yang bisa dijalankan di berbagai terminal (kayak aplikasi command line) pada komputer.
- **Bash Script**: Versi khusus dari Shell Script yang dirancang untuk terminal bernama Bash, yang paling sering dipakai di Linux.

## Perbedaan Utama
- **Shell Script**: Bisa dipakai di banyak jenis terminal, tapi kadang fiturnya terbatas.
- **Bash Script**: Khusus untuk Bash, punya fitur lebih lengkap, tapi kurang cocok dipakai di terminal lain.

## Kelebihan & Kekurangan

### Shell Script
- **Kelebihan**: 
  - Lebih fleksibel, bisa dipakai di berbagai jenis komputer.
- **Kekurangan**: 
  - Kurang fitur dan kadang beda-beda tergantung terminal yang dipakai.

**Contoh Shell Script**:
```sh
#!/bin/sh
echo "Hello, World!"
```
Penjelasan: Ini adalah script sederhana yang bisa jalan di banyak terminal dan cuma menampilkan tulisan "Hello, World!".

### Bash Script

- **Kelebihan**:
    - Punya fitur lebih lengkap dan seragam di Linux.
- **Kekurangan**:
    - Kurang cocok dipakai di terminal selain Bash.

**Contoh Bash Script**:
```sh
#!/bin/bash
name="Imron"
echo "Hello, $name!"
```
Penjelasan: Script ini menggunakan Bash, menampilkan "Hello, Imron!" dan hanya bisa jalan di terminal Bash.