# Jenkins Installation and Configuration Guide

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Docker & Docker Compose Installation](#docker--docker-compose-installation)
3. [Jenkins & Nginx Setup with Docker Compose](#jenkins--nginx-setup-with-docker-compose)
4. [SSH Key Configuration](#ssh-key-configuration)
5. [Reverse Proxy Configuration](#reverse-proxy-configuration)
6. [Jenkins Job Configuration](#jenkins-job-configuration)
7. [Discord Notification Setup](#discord-notification-setup)

## Prerequisites
- Ubuntu Server 20.04/22.04
- Minimal 2GB RAM
- 2 Core CPU
- 20GB Storage
- Domain yang sudah diarahkan ke IP server

## Docker & Docker Compose Installation

### 1. Update System
```bash
sudo apt update
sudo apt upgrade -y
```

### 2. Install Docker
```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker
```

### 3. Install Docker Compose
```bash
# Download Docker Compose
sudo docker run hello-world

# Verify installation
docker-compose --version
```

## Jenkins & Nginx Setup with Docker Compose

### 1. Create Project Directory
```bash
mkdir jenkins-project
cd jenkins-project
```

### 2. Create Docker Compose File
```bash
nano docker-compose.yml
```

Add the following content:
```yaml
services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins
    restart: unless-stopped
    privileged: true
    user: root
    ports:
      - 8080:8080
      - 50000:50000
    volumes:
      - ./jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - jenkins-network

  nginx:
    image: nginx:alpine
    container_name: nginx
    restart: unless-stopped
    ports:
      - 80:80
      - 443:443
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d
      - ./nginx/ssl:/etc/nginx/ssl
    depends_on:
      - jenkins
    networks:
      - jenkins-network

networks:
  jenkins-network:
    driver: bridge
```

### 3. Create Nginx Configuration
```bash
# Create directories
mkdir -p nginx/conf.d nginx/ssl

# Create Nginx config
nano nginx/conf.d/jenkins.conf
```

Add the following content:
```nginx
upstream jenkins {
  keepalive 32; # keepalive connections
  server 127.0.0.1:8080; # jenkins ip and port
}

# Required for Jenkins websocket agents
map $http_upgrade $connection_upgrade {
  default upgrade;
  '' close;
}

server {
  listen          80;       # Listen on port 80 for IPv4 requests

  server_name     jenkins.team1.studentdumbways.my.id;  # replace 'jenkins.example.com' with your server domain name

  # this is the jenkins web root directory
  # (mentioned in the output of "systemctl cat jenkins")
  root            /var/run/jenkins/war/;

  access_log      /var/log/nginx/jenkins.access.log;
  error_log       /var/log/nginx/jenkins.error.log;

  # pass through headers from Jenkins that Nginx considers invalid
  ignore_invalid_headers off;

  location ~ "^/static/[0-9a-fA-F]{8}\/(.*)$" {
    # rewrite all static files into requests to the root
    # E.g /static/12345678/css/something.css will become /css/something.css
    rewrite "^/static/[0-9a-fA-F]{8}\/(.*)" /$1 last;
  }

  location /userContent {
    # have nginx handle all the static requests to userContent folder
    # note : This is the $JENKINS_HOME dir
    root /var/lib/jenkins/;
    if (!-f $request_filename){
      # this file does not exist, might be a directory or a /**view** url
      rewrite (.*) /$1 last;
      break;
    }
    sendfile on;
  }

  location / {
      sendfile off;
      proxy_pass         http://jenkins;
      proxy_redirect     default;
      proxy_http_version 1.1;

      # Required for Jenkins websocket agents
      proxy_set_header   Connection        $connection_upgrade;
      proxy_set_header   Upgrade           $http_upgrade;

      proxy_set_header   Host              $http_host;
      proxy_set_header   X-Real-IP         $remote_addr;
      proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Proto $scheme;
      proxy_max_temp_file_size 0;

      #this is the maximum upload size
      client_max_body_size       10m;
      client_body_buffer_size    128k;

      proxy_connect_timeout      90;
      proxy_send_timeout         90;
      proxy_read_timeout         90;
      proxy_request_buffering    off; # Required for HTTP CLI commands
  }

}
```

### 4. Start Services
```bash
docker-compose up -d
```

### 5. Get Jenkins Initial Password
```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

## SSH Key Configuration

### 1. Generate SSH Key in Jenkins Container
```bash
# Enter Jenkins container
docker exec -it jenkins bash

# Generate SSH key
ssh-keygen -t rsa -b 4096 -C "team1@gmail.com"

# View public key
cat ~/.ssh/id_rsa.pub
```

### 2. Add Public Key to Target Server
Copy the public key and add it to `~/.ssh/authorized_keys` on your target server:
```bash
echo "YOUR_PUBLIC_KEY" >> ~/.ssh/authorized_keys
```

## Jenkins Job Configuration

### 1. Create New Pipeline Job
1. Go to Jenkins Dashboard
2. Click "New Item"
3. Enter name (e.g., "staging-pipeline")
4. Select "Pipeline"
5. Click "OK"

### 2. Configure Pipeline
Add the following pipeline script:

```groovy
pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = credentials('docker-image')
        DOCKER_TAG = credentials('docker-tag')
        DOCKER_HUB = credentials('docker-hub')
        REPO_URL = credentials('repo-url')
        DISCORD_WEBHOOK = credentials('discord-webhook')
        SSH_CREDENTIALS = credentials('ssh-host')
        SERVER_IP = credentials('server-ip')
        SSH_USER = credentials('ssh-user')
    }
    
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'staging',
                    url: "${REPO_URL}"
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', "${DOCKER_HUB}") {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }
        
        stage('Deploy Application') {
            steps {
                sshagent(["${SSH_CREDENTIALS}"]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${SSH_USER}@${SERVER_IP} '
                        docker compose stop frontend
                        docker compose pull frontend
                        docker compose up -d frontend
                        '
                    """
                }
            }
        }
    }
    
    post {
        success {
            discordSend description: "Build Succeeded!",
                       link: env.BUILD_URL,
                       result: currentBuild.currentResult,
                       title: env.JOB_NAME,
                       webhookURL: "${DISCORD_WEBHOOK}"
        }
        failure {
            discordSend description: "Build Failed!",
                       link: env.BUILD_URL,
                       result: currentBuild.currentResult,
                       title: env.JOB_NAME,
                       webhookURL: "${DISCORD_WEBHOOK}"
        }
    }
}

```

## Discord Notification Setup

### 1. Create Discord Webhook
1. Go to Discord Server Settings
2. Click "Integrations"
3. Click "Create Webhook"
4. Copy Webhook URL

### 2. Install Discord Notification Plugin
1. Go to Jenkins Dashboard
2. Navigate to "Manage Jenkins" > "Manage Plugins"
3. Go to "Available" tab
4. Search for "Discord Notifier"
5. Install the plugin
6. Restart Jenkins

### 3. Configure Discord Notification
1. Go to "Manage Jenkins" > "Configure System"
2. Find "Discord Notifier"
3. Add your Discord Webhook URL
4. Click "Test Connection"
5. Save configuration

## Verification Steps

1. Access Jenkins through your domain: `https://jenkins.team1.studentdumbways.my.id`
2. Login with your credentials
3. Run your pipeline job
4. Check Discord channel for notifications
5. Verify your application deployment

## Security Notes
- Keep your Jenkins instance updated
- Use strong passwords
- Regularly rotate SSH keys
- Use HTTPS for your domain
- Implement proper firewall rules
- Use Jenkins security best practices

## Troubleshooting

### Common Issues and Solutions:

1. Jenkins can't connect to Docker:
```bash
# Check Docker socket permissions
sudo chmod 666 /var/run/docker.sock
```

2. Nginx proxy errors:
```bash
# Check Nginx logs
docker logs nginx
```

3. Jenkins pipeline fails:
```bash
# Check Jenkins logs
docker logs jenkins
```

4. SSH connection issues:
```bash
# Test SSH connection
ssh -i /var/jenkins_home/.ssh/id_rsa -T user@your-server-ip
```