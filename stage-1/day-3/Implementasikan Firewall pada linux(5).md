# Implementasi Firewall di Linux Server

## Studi Kasus:
- **Server A** hanya bisa mengakses **WebServer** yang ada di **Server B**.
- Gunakan **UFW** untuk mengatur izin/protokol jaringan seperti **TCP** dan **UDP**.

## Langkah-langkah:

1. **Buat 2 Virtual Machine (VM)**
   - **Server A**: Ini adalah server yang akan mengakses WebServer di **Server B**.
   - **Server B**: Ini adalah server yang akan menjalankan WebServer.

2. **Cek ip server**
    - **server A**
      ![ip a(server a) ](assets/images/cek-ip-server-a(1).png) <br>

    - **server B** 
      ![ip a(server b) ](assets/images/ip-b(4).png) <br>

3. **Konfigurasi server b agar hanya bisa diakses server A**
   - **aktifkan ufw enable**
      ![sudo ufw enable) ](assets/images/ufw-enable(2).png) <br>
   
   - **setting ufw allow hanya bisa diakses ke server a**
      ![sudo ufw allow) ](assets/images/setting-ip-server-b(3).png) <br>

   - **setting ufw tcp dan udp dan hanya bisa diakses server a**
      ![sudo ufw allow) ](assets/images/add-tcp-udp(5).png) <br>

    - **server a akses ke server b**
      ![sudo ufw allow) ](assets/images/akses-keserver-b(6).png) <br>

    - **server a akses ke server b dengan port 22 tcp/udp**
      ![telnet ip server b) ](assets/images/telnet-server-udp-tcp.png) <br>

    - **server lain coba akses ke server b**
      ![failed ip server b) ](assets/images/server-lain-not-acces-b(7).png) <br>