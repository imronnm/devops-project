### 1. Buat Akun GitLab
- Pertama, kunjungi [GitLab](https://gitlab.com/) dan buat akun.

### 2. Push Repository
- Setelah membuat akun, buat proyek baru di GitLab.
- Push kode aplikasi frontend ke repository yang baru dibuat.

### 3. Buat File `.gitlab-ci.yml`
- Di dalam direktori proyek yang sudah push, buat file bernama `.gitlab-ci.yml`. File ini akan digunakan untuk mengatur pipeline CI/CD. Berikut adalah contoh isi file tersebut:

```yaml
stages:
  - build
  - deploy_staging
  - deploy_production

variables:
  DOCKER_DRIVER: overlay2

before_script:
  - echo "$DOCKER_HUB_PASSWD" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin || true
  - apt-get update && apt-get install -y wget

build:
  stage: build
  image: docker:latest 
  services:
    - docker:dind
  script:
    - docker build -t imronnm/frontendgitlab:latest .
    - docker push imronnm/frontendgitlab:latest
  after_script:
    - docker image prune -af
    - |
      wget --spider --header="Content-Type: application/json" \
      --post-data='{"content": " Build Done✅! Deployment is starting."}' \
      $DISCORD_WEBHOOK || echo "Failed to send notification"

deploy_staging:
  stage: deploy_staging
  image: docker:latest
  services:
    - docker:dind
  script:
    - echo "$SSH_KEY" > id_rsa
    - chmod 600 id_rsa
    - |
      ssh -i id_rsa -o StrictHostKeyChecking=no $SSH_USER '
        set -e
        docker compose -f ~/frontend/docker-compose.yml down || echo "Failed to stop containers"
        docker pull imronnm/frontendgitlab:latest || echo "Failed to pull image"
        docker compose -f ~/frontend/docker-compose.yml up -d || echo "Failed to start containers"
      '
    - rm id_rsa 
  after_script:
    - docker image prune -af
    - |
      wget --spider --header="Content-Type: application/json" \
      --post-data='{"content": "🚀 *Deploy Staging Sukses!!🔥"}' \
      $DISCORD_WEBHOOK || echo "Failed to send notification"
    - |
      # Wget spider untuk cek halaman di domain staging
      wget --spider -r -nd -nv -l 2 https://team1.studentdumbways.my.id/ || echo "Some pages might be unreachable"
  rules:
    - if: '$CI_COMMIT_BRANCH == "staging"'

deploy_production:
  stage: deploy_production
  image: docker:latest
  services:
    - docker:dind
  script:
    - echo "$SSH_KEY" > id_rsa
    - chmod 600 id_rsa
    - |
      ssh -i id_rsa -o StrictHostKeyChecking=no $SSH_USER '
        set -e
        docker compose -f ~/frontend/docker-compose.yml down || echo "Failed to stop containers"
        docker pull imronnm/frontendgitlab:latest || echo "Failed to pull image"
        docker compose -f ~/frontend/docker-compose.yml up -d || echo "Failed to start containers"
      '
    - rm id_rsa 
  after_script:
    - docker image prune -af 
    - |
      wget --spider --header="Content-Type: application/json" \
      --post-data='{"content": "🚀 *Deploy Production Sukses!!🔥 Aplikasi kita udah live di production! Cek deh! 👀."}' \
      $DISCORD_WEBHOOK || echo "Failed to send notification"
    - |
      # Wget spider untuk cek halaman di domain production
      wget --spider -r -nd -nv -l 2 https://team1.studentdumbways.my.id/ || echo "Some pages might be unreachable"
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
```
### 4. Fitur
Dalam konfigurasi CI/CD .gitlab-ci.yml ini, kita telah mengimplementasikan:

    wgetspider: Alat ini digunakan untuk menguji domain aplikasi kita dengan melakukan pemeriksaan terhadap semua link di dalam aplikasi. Jika ada link yang mengarah ke halaman 404 (tidak ditemukan), maka akan memberikan peringatan.
    Notifikasi ke Discord: Setelah proses deployment selesai, notifikasi akan dikirim ke saluran Discord.
    Auto Trigger: Pipeline akan otomatis berjalan setiap kali ada perubahan pada kode di repository SCM.


  git config --global user.email "iyaron08@gmail.com"
  git config --global user.name "imronnm"