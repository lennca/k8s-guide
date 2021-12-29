#!/bin/bash

file=hosts
user=ubuntu
master_ip=<master-ip>
worker_ip=<slave-ip>
key_path=<path-to-key>

# If hosts file already exists, remove
if [ -e ./$file ]; then
  rm ./$file
fi

# Write to hosts file

cat > ./$file <<EOL
[masters]
#${master-name} ansible_host=${master-ip} ansible_user=ubuntu
k8-master ansible_host=$master_ip ansible_user=$user

[workers]
#${worker-name} ansible_host=${worker-ip} ansible_user=ubuntu
k8-worker ansible_host=$worker_ip ansible_user=$user

#[bastions]
#${bastion-name} ansible_host=${bastion-private} ansible_user=ubuntu

[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -q -i $key_path $user@$master_ip"'
ansible_ssh_user=$user
ansible_python_interpreter=/usr/bin/python3
EOL
