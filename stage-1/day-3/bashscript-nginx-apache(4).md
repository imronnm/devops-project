# Bash Script untuk Instalasi Web Server

Script ini memungkinkan Anda untuk memilih dan menginstal web server Nginx atau Apache2 dengan mudah.

## Script

```bash
#!/bin/bash

echo "Pilih web server yang ingin diinstal:"
echo "1. Nginx"
echo "2. Apache2"
read -p "Masukkan pilihan (1 atau 2): " pilihan

if [ "$pilihan" -eq 1 ]; then
    echo "Menginstal Nginx..."
    sudo apt update
    sudo apt install -y nginx

elif [ "$pilihan" -eq 2 ]; then
    echo "Menginstal Apache2..."
    sudo apt update
    sudo apt install -y apache2
else
    echo "Pilihan tidak valid. Silakan pilih 1 atau 2."
fi
```
## Cara Menggunakan
1. Simpan script ini sebagai install_webserver.sh.
2. Beri izin eksekusi dengan perintah:
3. sudo chmod 777 install_webserver.sh
4. Jalankan script dengan perintah:
5. ./install_webserver.sh

