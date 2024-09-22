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
   CREATE TABLE transactions (
   transaction_id INT AUTO_INCREMENT PRIMARY KEY,
   customer_id INT NOT NULL,
   transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
   total_amount DECIMAL(10, 2) NOT NULL,
   transaction_status VARCHAR(50) NOT NULL,
   description TEXT
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
mysql -u admin_user -p
SET ROLE 'admin';
show databases;
use demo
INSERT INTO transactions (customer_id, transaction_date, total_amount, transaction_status, description) VALUES
(1, '2024-01-01 10:30:00', 100.50, 'Completed', 'Pembelian produk A'),
(2, '2024-01-02 14:20:00', 250.75, 'Pending', 'Pembelian produk B'),
(3, '2024-01-03 16:45:00', 75.00, 'Cancelled', 'Pembelian produk C, transaksi dibatalkan'),
(4, '2024-01-04 09:10:00', 300.00, 'Completed', 'Pembelian produk D dan E'),
(5, '2024-01-05 12:00:00', 50.25, 'Completed', 'Pembelian produk F'),
(6, '2024-01-06 18:30:00', 120.00, 'Pending', 'Pembelian produk G'),
(7, '2024-01-07 11:15:00', 200.00, 'Completed', 'Pembelian produk H, diskon 10%'),
(8, '2024-01-08 15:50:00', 180.75, 'Refunded', 'Pembelian produk I, transaksi dikembalikan'),
(9, '2024-01-09 17:25:00', 220.40, 'Completed', 'Pembelian produk J dan K'),
(10, '2024-01-10 13:05:00', 400.00, 'Completed', 'Pembelian produk L, M, dan N');

```

- sekarang coba akses ke guesta pakah bisa menambahkan data ke database demo

```bash
mysql -u guest_user -p
SET ROLE 'guest';
show databases;
use demo;
-- Insert data dummy ke dalam tabel transactions
INSERT INTO transactions (customer_id, transaction_date, total_amount, transaction_status, description) VALUES
(10, '2024-02-01 08:30:00', 500.00, 'Completed', 'Pembelian produk X'),
(11, '2024-02-02 09:45:00', 150.75, 'Completed', 'Pembelian produk Y dengan diskon'),
(12, '2024-02-03 10:55:00', 89.99, 'Pending', 'Pembelian produk Z, menunggu konfirmasi'),
(13, '2024-02-04 11:20:00', 250.00, 'Cancelled', 'Pembelian produk A dibatalkan'),
(14, '2024-02-05 12:00:00', 75.60, 'Completed', 'Pembelian produk B'),
(15, '2024-02-06 13:15:00', 320.20, 'Refunded', 'Pembelian produk C, transaksi dikembalikan'),
(16, '2024-02-07 14:30:00', 410.00, 'Completed', 'Pembelian produk D dan E'),
(17, '2024-02-08 15:45:00', 95.75, 'Pending', 'Pembelian produk F, menunggu pembayaran'),
(18, '2024-02-09 16:50:00', 180.30, 'Completed', 'Pembelian produk G dan H'),
(19, '2024-02-10 17:05:00', 215.00, 'Completed', 'Pembelian produk I'),
(20, '2024-02-11 18:20:00', 140.90, 'Cancelled', 'Pembelian produk J dibatalkan');
```

### 3. Remote User
1. **Remote Database dari Komputer Lokal:**
   - Pastikan Anda telah mengatur bind address dengan benar dan dapat mengakses dari IP lokal.
```bash
   sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
   bind-address = 0.0.0.0   
```

- jangan lupa restart mysql server
```bash
sudo systemctl restart mysql
```

   - buat user baru untuk di remote
```bash
CREATE USER 'dumbflix'@'%' IDENTIFIED BY 'Satria150';
GRANT ALL PRIVILEGES ON *.* TO 'dumbflix'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

   - Gunakan `mysql-client` dari komputer lokal:

```bash
mysql -u dumbflix -p -h <IP_SERVER> 
```