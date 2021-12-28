#!/bin/bash
# Inspiration: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
# Inspiration: https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker

# 1. Install Docker
sudo apt-get update

# Setup repository
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -qq

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine (20.10)
sudo apt-get update

# To list version available in repo: apt-cache madison docker-ce
sudo apt-get install docker-ce=5:20.10.0~3-0~ubuntu-focal docker-ce-cli=5:20.10.0~3-0~ubuntu-focal containerd.io -qq



# 2. Configure Docker for K8s
# Configure Docker daemon
sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# Restart Docker and enable on boot:
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker
