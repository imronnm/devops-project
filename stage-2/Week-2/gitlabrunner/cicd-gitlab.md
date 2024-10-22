### 1. Buat Akun GitLab
- Pertama, kunjungi [GitLab](https://gitlab.com/) dan buat akun.

### 2. Push Repository
- Setelah membuat akun, buat proyek baru di GitLab.
- Push kode aplikasi frontend ke repository yang baru dibuat.

### 3. Buat File `.gitlab-ci.yml`
- Di dalam direktori proyek yang sudah push, buat file bernama `.gitlab-ci.yml`. File ini akan digunakan untuk mengatur pipeline CI/CD. Berikut adalah contoh isi file tersebut:

```yaml
variables:
  IMAGE: imronnm/frontendgitlab
  TAG: latest
  DIR: /home/team1-fe/apps/frontendgitlab
  CONTAINER_NAME: fe-staging
  DOCKER_USERNAME: imronnm
  DOCKER_PASSWORD: $DOCKER_PASSWORD
  DOCKER_REGISTRY: imronnm/frontendgitlab
  DISCORD_WEBHOOK: "https://discord.com/api/webhooks/xxx/xxx"

stages:
  - pull
  - build
  - test
  - push
  - deploy
  - notification

.setup_ssh: &setup_ssh
  before_script:
    - 'command -v ssh-agent >/dev/null || ( apk add --update openssh )'
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - ssh-keyscan $SSH_HOST >> ~/.ssh/known_hosts
    - chmod 644 ~/.ssh/known_hosts

# Pull Stage
pull:
  stage: pull
  image: docker:latest
  <<: *setup_ssh
  script:
    - echo "Pulling the latest code from Git"
    - ssh $SSH_USER@$SSH_HOST "cd $DIR && git checkout staging && git pull origin staging"
  after_script:
    - echo "Git pull successful"

# Build Stage
build:
  stage: build
  image: docker:latest
  <<: *setup_ssh
  script:
    - echo "Building Docker image"
    - ssh $SSH_USER@$SSH_HOST "cd $DIR && docker build -t $IMAGE:$TAG ."
  after_script:
    - echo "Docker build successful"

# Test Stage
test:
  stage: test
  image: node:alpine  # Using a Node.js image for running npm commands
  <<: *setup_ssh
  script:
    - echo "Deleting running container if exists"
    - ssh $SSH_USER@$SSH_HOST "docker rm -f $CONTAINER_NAME || true"
    - echo "Building Docker image for testing"
    - ssh $SSH_USER@$SSH_HOST "cd $DIR && docker build -t $IMAGE:$TAG ."
    - echo "Running tests"
    - ssh $SSH_USER@$SSH_HOST "cd $DIR && docker run --rm $IMAGE:$TAG npm run test"  # Run tests in the Docker container
  after_script:
    - echo "Test stage completed successfully"

# Push Stage
push:
  stage: push
  image: docker:latest
  <<: *setup_ssh
  script:
    - echo "Tagging Docker image"
    - ssh $SSH_USER@$SSH_HOST "docker tag $IMAGE:$TAG $DOCKER_REGISTRY:staging"
    - echo "Pushing Docker image to registry"
    - "docker push $DOCKER_REGISTRY:staging"
  after_script:
    - echo "Docker image pushed successfully"

# Deploy Stage
deploy:
  stage: deploy
  image: docker:latest
  <<: *setup_ssh
  script:
    - echo "Deploying application"
    - ssh $SSH_USER@$SSH_HOST "cd $DIR && docker-compose stop frontend"
    - ssh $SSH_USER@$SSH_HOST "cd $DIR && docker-compose pull frontend"
    - ssh $SSH_USER@$SSH_HOST "cd $DIR && docker-compose up -d frontend"
    - ssh $SSH_USER@$SSH_HOST "cd $DIR && docker image prune -af"
  after_script:
    - echo "Deployment successful"

# Success Notification Stage
success_notification:
  stage: notification
  script:
    - wget https://raw.githubusercontent.com/DiscordHooks/gitlab-ci-discord-webhook/master/send.sh
    - chmod +x send.sh
    - ./send.sh success $DISCORD_WEBHOOK
  when: on_success

# Failure Notification Stage
failure_notification:
  stage: notification
  script:
    - wget https://raw.githubusercontent.com/DiscordHooks/gitlab-ci-discord-webhook/master/send.sh
    - chmod +x send.sh
    - ./send.sh failure $DISCORD_WEBHOOK
  when: on_failure

```
### 4. Fitur
Dalam konfigurasi CI/CD .gitlab-ci.yml ini, kita telah mengimplementasikan:

    wgetspider: Alat ini digunakan untuk menguji domain aplikasi kita dengan melakukan pemeriksaan terhadap semua link di dalam aplikasi. Jika ada link yang mengarah ke halaman 404 (tidak ditemukan), maka akan memberikan peringatan.
    Notifikasi ke Discord: Setelah proses deployment selesai, notifikasi akan dikirim ke saluran Discord.
    Auto Trigger: Pipeline akan otomatis berjalan setiap kali ada perubahan pada kode di repository SCM.


  git config --global user.email "iyaron08@gmail.com"
  git config --global user.name "imronnm"