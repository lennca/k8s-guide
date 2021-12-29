#!/bin/bash

hosts_file=hosts
config_file=ansible.cfg
user=ubuntu
master_ip=<master-ip>
worker_ip=<slave-ip>
key_path=<path-to-key>

# Create hosts file
# If hosts file already exists, remove
if [ -e ./$hosts_file ]; then
  rm ./$hosts_file
fi

# Write to hosts file
cat > ./$hosts_file <<EOL
[masters]
k8-master ansible_host=$master_ip ansible_user=$user

[workers]
k8-worker ansible_host=$worker_ip ansible_user=$user

#[bastions]
#${bastion-name} ansible_host=${bastion-private} ansible_user=ubuntu

[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -q -i $key_path $user@$master_ip"'
ansible_ssh_user=$user
ansible_python_interpreter=/usr/bin/python3
EOL


# Create ansible.cfg file
# If hosts file already exists, remove
if [ -e ./$config_file ]; then
  rm ./$config_file
fi

cat > ./$config_file <<EOL
[defaults]
inventory = ./$hosts_file
remote_user = $user
private_key_file = $key_path
command_warnings=False
deprecation_warnings=False
# To ignore known_hosts issue
host_key_checking=False
EOL
