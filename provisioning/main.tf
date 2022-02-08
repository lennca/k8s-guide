terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.46.0"
    }
  }
}

provider "openstack" {
  user_name   = var.user_name
  tenant_name = var.tenant_name
  password    = var.password
  auth_url    = var.auth_url
  region      = var.region
  tenant_id   = var.tenant_id
}

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
}

/* Create Ansible inventory file */
resource "local_file" "ansible_inventory" {
  depends_on = [
    module.network, module.sec_group, module.instance
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

/* Create Ansible config file */
resource "local_file" "ansible_config" {
  depends_on = [
    module.network, module.sec_group, module.instance
  ]

  content = templatefile("config.tftpl", {
    key_name     = var.key_name
    }
  )
  filename = "../configuration/ansible.cfg"
}

/* Delay Ansible execution (wait for resources to be fully launched) */
resource "time_sleep" "wait_30_seconds" {
  depends_on = [
    module.network, module.sec_group, module.bastion, module.instance, resource.local_file.ansible_inventory, resource.local_file.ansible_config
  ]

  create_duration = "30s"
}

resource "null_resource" "execfile" {
  depends_on = [
    time_sleep.wait_30_seconds
  ]

  # Prep the key for Ansible
  provisioner "local-exec" {
    #remove entity from known_hosts ssh-keygen -R hostname
    #add entity to known_hosts ssh-keyscan $ip >> ~/.ssh/known_hosts)
    command = "(ssh-keygen -R $ip ; ssh-keyscan -H $ip >> ~/.ssh/known_hosts ; eval `ssh-agent` ; ssh-add -k ~/.ssh/$keyName ; scp ~/.ssh/$keyName ubuntu@$ip:.ssh ; ssh -t ubuntu@$ip ; chmod 600 ~/.ssh/$keyName)"
    environment = {
      ip      = module.bastion.bastion_float
      keyName = var.key_name
    }
  }


  # Run Ansible playbook
  provisioner "local-exec" {
    command = "(cd ../configuration ; ansible-playbook -i hosts main.yaml)"
  }
}

/* Print bastion float ip */
output "loadbalancer_public_ip" {
  value       = module.bastion.bastion_float
  description = "Bastion public ip"
}
