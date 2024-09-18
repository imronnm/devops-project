# Panduan Pengerjaan Tugas MySQL

## Tujuan

Tugas ini bertujuan untuk melakukan konfigurasi dan deployment MySQL dengan berbagai pengaturan termasuk keamanan, pembuatan user dan database, serta hak akses berbasis peran.

## Langkah-Langkah Pengerjaan

### 1. Deploy Database MySQL

1. **Install MySQL:**
   - Pastikan MySQL telah terinstall di server.
   - jika belum install terlebih dahulu
```bash
   sudo apt install mysql-server
```

2. **Setup Secure Installation:**
   - Jalankan perintah berikut untuk menjalankan setup keamanan dasar:
     ```bash
     sudo mysql_secure_installation
     ```

3. **Set Password untuk User `root`:**
   - Login ke MySQL:
     ```bash
     sudo mysql -u root
     ```
   - Set password untuk user `root`:
     ```sql
     ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';
     FLUSH PRIVILEGES;
     ```

4. **Buat User Baru untuk MySQL:**
   - Masih dalam sesi MySQL, buat user baru:
     ```sql
     CREATE USER 'new_user'@'localhost' IDENTIFIED BY 'user_password';
     ```

5. **Buat Database Baru:**
   - Buat database baru:
     ```sql
     CREATE DATABASE new_database;
     ```

6. **Beri Hak Akses untuk User Baru:**
   - Berikan hak akses pada user baru untuk database:
     ```sql
     GRANT ALL PRIVILEGES ON new_database.* TO 'new_user'@'localhost';
     FLUSH PRIVILEGES;
     ```

7. **Ubah Bind Address MySQL:**
   - Edit file konfigurasi MySQL:
     ```bash
     sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
     ```
   - Temukan baris `bind-address` dan sesuaikan dengan IP server  atau gunakan `0.0.0.0` untuk akses dari semua IP:
     ```
     bind-address = 0.0.0.0
     ```
   - Restart MySQL untuk menerapkan perubahan:
     ```bash
     sudo systemctl restart mysql
     ```

### 2. Role Based

1. **Buat Database dan Tabel Dummy:**
   - Buat database baru dan tabel dummy:
     ```sql
     CREATE DATABASE demo;
     USE demo;
     CREATE TABLE transaction (
       id INT AUTO_INCREMENT PRIMARY KEY,
       description VARCHAR(255) NOT NULL,
       amount DECIMAL(10,2) NOT NULL
     );
     ```

2. **Buat Role `admin` dan `guest`:**
   - Buat role:
     ```sql
     CREATE ROLE admin;
     CREATE ROLE guest;
     ```

3. **Berikan Hak Akses pada Role `admin`:**
   - Berikan hak akses pada role `admin`:
     ```sql
     GRANT SELECT, INSERT, UPDATE, DELETE ON demo.transaction TO admin;
     ```

4. **Berikan Hak Akses pada Role `guest`:**
   - Berikan hak akses pada role `guest`:
     ```sql
     GRANT SELECT ON demo.transaction TO guest;
     ```

5. **Buat User dan Tambahkan ke Role:**
   - Buat user dan tambahkan ke role:
     ```sql
     CREATE USER 'your_name'@'localhost' IDENTIFIED BY 'your_password';
     GRANT admin TO 'your_name'@'localhost';

     CREATE USER 'guest'@'localhost' IDENTIFIED BY 'guest';
     GRANT guest TO 'guest'@'localhost';
     ```

6. **Uji Semua User:**
   - Login dengan setiap user dan pastikan hak akses berfungsi sesuai yang diatur.

```bash
   mysql -u admin
   show databases;
   use demo;
   INSERT INTO transaction (description) VALUES 
('Transaction 1'),
('Transaction 2'),
('Transaction 3'),
('Transaction 4'),
('Transaction 5');

   ```

- sekarang coba akses ke guestapakah bisa menambahkan data ke database demo

```bash
INSERT INTO transaction (description) VALUES 
('Transaction 6'),
('Transaction 7'),
('Transaction 8'),
('Transaction 9'),
('Transaction 10');
```
### 3. Remote User

1. **Remote Database dari Komputer Lokal:**
   - Pastikan Anda telah mengatur bind address dengan benar dan dapat mengakses dari IP lokal.
   - Gunakan `mysql-client` dari komputer lokal:
     ```bash
     mysql -u your_name -p -h <IP_SERVER> 
     ```
   - Masukkan password jika diminta dan verifikasi koneksi serta hak akses.