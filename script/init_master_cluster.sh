#!/bin/bash
# Inspiration: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#initializing-your-control-plane-node
# Inspiration: https://kubernetes.io/docs/concepts/cluster-administration/addons/#networking-and-network-policy
# Inspiration: https://projectcalico.docs.tigera.io/getting-started/kubernetes/self-managed-onprem/onpremises

sudo kubeadm init --pod-network-cidr=192.168.0.0/16

# Outputted command to start cluster
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


# Add Calico pod network - if ip 192.168.0.0/16 -> no changes in yaml needed
curl https://docs.projectcalico.org/manifests/calico.yaml -O

kubectl apply -f calico.yaml


