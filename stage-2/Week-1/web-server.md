# Tugas Reverse Proxy dan SSL

## 1: Install Nginx

```bash
   sudo apt update
   sudo apt install nginx -y
```

## 2: Setup Reverse Proxy
1. Set up front end reverse proxy
```bash
sudo nano /etc/nginx/apps/frontend

server {
    server_name imron.studentdumbways.my.id;

    location / {
        proxy_pass http://localhost:3000; 
    }
}
```

2. Set up back end reverse proxy
```bash
sudo nano /etc/nginx/apps/backend

server {
    server_name api.imron.studentdumbways.my.id;

    location / {
        proxy_pass http://localhost:5000; 
    }
}
```

## 3: simpan dan restart nginx
```bash
sudo nano /etc/nginx/nginx.conf 
```
1. tambahkan file konfigurasi berikut ke dalam file nginx.conf 
```bash
include /etc/nginx/imron/*;
```
2. kemudian cek status dan restart nginx
```bash
sudo nginx -t
sudo nginx restart nginx
```

## 3: Install Certbot untuk SSL
1. install certbot
```bash
sudo apt install certbot python3-certbot-nginx -y
```
2. Generate SSL untuk domain frontend:
```bash
sudo certbot --nginx -d imron.studentdumbways.my.id
```
3. Generate SSL untuk domain backend:
```bash
sudo certbot --nginx -d api.imron.studentdumbways.my.id
```

## 4: Implementasi Wildcard SSL
1. buat file untuk api dan username dari api global cloudflare
```bash
sudo nano /etc/letsencrypt/cloudflare.ini
dns_cloudflare_email = "email login cloudflare"
dns_cloudflare_api_key = "masukkan api global cloudflare"
```
2. Izin Akses: Pastikan file cloudflare.ini memiliki izin yang tepat agar hanya bisa diakses oleh root. 
```bash
sudo chmod 600 /etc/letsencrypt/cloudflare.ini
```
3. Generate Wildcard SSL dengan Certbot 
```bash
sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini -d "*.studentdumbways.my.id" -d "studentdumbways.my.id"
```



