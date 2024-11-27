#!/bin/bash

# Prevent interactive prompts during installation
export DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    python3-pip

# Set up GitHub Account
git config --global user.email "${github_email}"
git config --global user.name "${github_user_name}"

# Install Docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Add the 'ubuntu' user to the 'docker' group
sudo usermod -aG docker ubuntu

# Install Kaggle API and create credentials
pip3 install kaggle
sudo mkdir -p /home/ubuntu/.kaggle
echo '${kaggle_json}' > /home/ubuntu/.kaggle/kaggle.json
sudo chmod 600 /home/ubuntu/.kaggle/kaggle.json
sudo chown ubuntu:ubuntu /home/ubuntu/.kaggle/kaggle.json

# Update PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> /home/ubuntu/.bashrc
source /home/ubuntu/.bashrc
