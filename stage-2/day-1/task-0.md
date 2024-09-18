# Deployment Setup Documentation

## Requirments
- Appserver untuk deploying Database.
- Gateway untuk deploying Frontend Application, Backend Application, dan Web Server.

## Tasks
1. Membuat user baru untuk semua server.
2. Mengatur agar server hanya dapat login dengan SSH-KEY tanpa menggunakan password.

## Langkah-langkah Pengerjaan

### 1. Persiapan Server
- Siapkan dua server: Appserver dan Gateway.

### 2. Membuat User Baru di Server app dan gateway 
- Login ke server gateway dan buat user baru:
```bash
  sudo adduser imronserver
```

- Berikan hak akses sudo
```bash
  sudo usermod -aG sudo imronserver
```

- Login ke server app dan buat user baru:
```bash
  sudo adduser imron
```

- Berikan hak akses sudo
```bash
  sudo usermod -aG sudo imron
```

### 3. Konfigurasi Autentikasi SSH-KEY
- Buat SSH key di server apps:
```bash
su - imron
ssh-keygen
```

- Copy SSH public key apps ke server:
```bash
cd /.ssh
cat id_rsa.pub
```
- buka server gateway buat folder baru dan tambahkan ssh authorized_keys untuk kuncinya
```bash
su - imronserver
sudo mkdir -p /home/imronserver/.ssh
sudo nano /home/imronserver/.ssh/authorized_keys
```

- Nonaktifkan login password:
```bash
sudo nano /etc/ssh/sshd_config
PubkeyAuthentication yes
PasswordAuthentication no
```
- Restart SSH
```bash
sudo systemctl restart ssh
```

### 4. Verifikasi Konfigurasi
-  akses ke user apps lalu koneksikan ke ssh ke server gateway:

```bash
ssh imronserver@150.127.136.6
```