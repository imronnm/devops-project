### 1. Membuat User Baru
```bash
sudo adduser team1
masukkan password team1
sudo usermod -aG team1
```

### 2. membuat script bash untuk install docker
ada fi file installdocker.sh

### 3. Deploy Aplikasi dengan Docker Compose 

- **Staging**

disini kita membutuhkan 1 cloud provider

Buat file docker-compose.yml yang berisi:

    Web Server
    Frontend
    Backend
    Database

``` bash
team1@staging:~/team1-docker$ cat docker-compose.yml 
services:
  db:
    image: mysql:latest
    restart: always
    environment:
      MYSQL_DATABASE: wayshub
      MYSQL_USER: team1
      MYSQL_PASSWORD: team1
      MYSQL_ROOT_PASSWORD: team1
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - team1
    ports:
      - "3306:3306"

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    image: team1/dumbflx/frontend:staging
    restart: always
    networks:
      - team1
    depends_on:
      - backend
    ports:
      - "3000:3000"

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    image: team1/dumbflx/backend:staging
    restart: always
    networks:
      - team1
    environment:
      DB_HOST: db
      DB_USER: team1
      DB_PASSWORD: team1
      DB_NAME: wayshub
    depends_on:
      - db
    ports:
      - "5000:5000"

  nginx:
    image: nginx:latest
    restart: always
    ports:
      - "80:80"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/conf.d/default.conf
    networks:
      - team1
    depends_on:
      - frontend
      - backend

networks:
  team1:
    driver: bridge

volumes:
  db_data:

```

- **Production**
disini kita membutuhkan 2 cloud provider

Buat file docker-compose.yml yang berisi:

1 cloud provider untuk 
    Frontend1 as container
    Frontend2 as container

1 cloud provider untuk
    Backend1 as container
    Backend2 as container

- docker compose frontend
```bash
frontend1:
    container_name: frontend1
    image: team1/dumbflx/frontend:production  
    ports:
      - "3001:3000"
    networks:
      - team1

  frontend2:
    container_name: frontend2
    image: team1/dumbflx/frontend:production 
    ports:
      - "3002:3000"
    networks:
      - team1

networks:
  team1:
    driver: bridge
```

- docker compose backend 
```bash
services:
   backend-1:
      container_name: backend-1
      build:
         context: ./backend
         dockerfile: Dockerfile
      image: team1/dumbflix/backend:production
      restart: always
      networks:
         - team1
      environment:
         DB_HOST: 34.87.167.172 # IP Address VM Database
         DB_USERNAME: team1
         DB_PASSWORD: team1
         DB_NAME: wayshub
      ports:
         - "5000:5000"

   backend-2:
      container_name: backend-2
      build:
         context: ./backend
         dockerfile: Dockerfile
      image: team1/dumbflix/backend:production
      restart: always
      networks:
         - team1
      environment:
         DB_HOST: 34.87.167.172 # IP Address VM Database
         DB_USER: team1
         DB_PASSWORD: team1
         DB_NAME: wayshub
      ports:
         - "5001:5000"

networks:
   team1:
      driver: bridge
```

### 4. Membuat image dengan multistage dan image alpine agar lebih ringan
- Dockerfile Frontend

- implementasi multistage dan pm2 runtime 
```bash
FROM node:14-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci  
COPY . .
RUN npm run build
FROM node:14-alpine
WORKDIR /app
COPY --from=build /app ./
RUN npm i pm2 -g
COPY ecosystem.config.js ./
CMD [ "pm2-runtime", "ecosystem.config.js" ]
```

### 4. NGINX Reverse Proxy dan ssl certbot dns wildcard
- kita membutuhkan 1 cloud provider untuk nginx 

```bash
server {
        listen 80;
        server_name team1.studentdumbways.my.id;
        return 301 https://$host$request_uri;  # Redirect ke HTTPS
    }

    server {
        listen 443 ssl;
        server_name team1.studentdumbways.my.id;

        ssl_certificate /etc/letsencrypt/live/studentdumbways.my.id/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/studentdumbways.my.id/privkey.pem;

        location / {
            set $target http://35.240.173.197:3001;
            proxy_pass $target;
        }
    }

```

- cerbot dns wildcard with dns cloudflare
```bash
sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini -d "*.team1.studentdumbways.my.id" -d "team1.studentdumbways.my.id"
```

### 5. Push Image ke docker registry
```bash
# Login ke Docker Hub
docker login

# Tag gambar
docker tag my-image:latest imronnm/my-repo:latest

# Push gambar
docker push imronnm/my-repo:latest
```

### 6. Pengujian Aplikasi
- cek aplikasi frontend dan lakukan register jika sukses berarti aplikasi berjalan dengan baik
       ![registrysucces](Screenshot%20from%202024-09-29%2015-17-57.png) <br>