module "network" {
  source              = "./modules/network/"
  external_network_id = var.external_network_id
}

module "sec_group" {
  source   = "./modules/sec_group/"
  ssh_name = var.ssh_name
}

module "bastion" {
  source       = "./modules/bastion/"
  depends_on   = [module.network, module.sec_group]
  key_pair     = var.key_pair
  network_name = module.network.network_name
  sec_groups   = ["default", var.ssh_name]
}

module "instance" {
  source       = "./modules/instance/"
  depends_on   = [module.network]
  key_pair     = var.key_pair
  network_name = module.network.network_name
  instances    = var.instances
  secgroup_nodeport = module.sec_group.secgroup_nodeport
}

module "loadbalancer" {
  depends_on    = [module.network, module.sec_group, module.instance, module.bastion]
  source        = "./modules/loadbalancer/"
  address       = module.instance.worker_ip
  vip_subnet_id = module.network.vip_subnet_id
  sec_group_ids  = module.sec_group.sec_group_ids
}

# Create Ansible inventory file.
resource "local_file" "ansible_inventory" {
  depends_on = [
    module.network, module.sec_group, module.instance, module.loadbalancer
  ]

  content = templatefile("hosts.tftpl", {
    master_name     = module.instance.master_name,
    master_ip       = module.instance.master_ip,
    worker_name     = module.instance.worker_name,
    worker_ip       = module.instance.worker_ip,
    bastion_ip      = module.bastion.bastion_ip,
    bastion_name    = module.bastion.bastion_name,
    bastion_float   = module.bastion.bastion_float,
    key_name        = var.key_name
    }
  )
  filename = "../configuration/hosts"
}

# Create Ansible config file.
resource "local_file" "ansible_config" {
  depends_on = [
    module.network, module.sec_group, module.instance, module.loadbalancer
  ]

  content = templatefile("config.tftpl", {
    key_name     = var.key_name
    }
  )
  filename = "../configuration/ansible.cfg"
}

# Delay Ansible execution (wait for resources to be fully launched).
resource "time_sleep" "wait_30_seconds" {
  depends_on = [
    module.network, module.sec_group, module.bastion, module.instance, module.loadbalancer, resource.local_file.ansible_inventory, resource.local_file.ansible_config
  ]

  create_duration = "30s"
}

resource "null_resource" "execfile" {
  depends_on = [
    time_sleep.wait_30_seconds
  ]

  # Prepare the key for Ansible.
  provisioner "local-exec" {
    # remove entity from known_hosts -> ssh-keygen -R hostname
    # add entity to known_hosts -> ssh-keyscan $ip >> ~/.ssh/known_hosts)
    command = "(ssh-keygen -R $ip ; ssh-keyscan -H $ip >> ~/.ssh/known_hosts ; eval `ssh-agent` ; ssh-add -k ~/.ssh/$keyName ; scp ~/.ssh/$keyName ubuntu@$ip:.ssh ; ssh -t ubuntu@$ip ; chmod 600 ~/.ssh/$keyName)"
    environment = {
      ip      = module.bastion.bastion_float
      keyName = var.key_name
    }
  }

}
resource "null_resource" "execfile2" {
  count = var.run_ansible == "yes" ? 1 : 0
  depends_on = [
    time_sleep.wait_30_seconds, null_resource.execfile
  ]

  # Run Ansible playbook.
  provisioner "local-exec" {
    command = "(cd ../configuration ; ansible-playbook -i hosts main.yaml)"
  }
}

/* Print bastion float ip, master private ip, and load balancer float ip. */
output "bastion_public_ip" {
  value       = module.bastion.bastion_float
  description = "Bastion floating ip."
}

output "master_private_ip" {
  value       = module.instance.master_ip
  description = "Master private ip."
}

output "load_balancer_ip" {
  value       = module.loadbalancer.lb_public_ip
  description = "Load Balancer floating ip."
}
