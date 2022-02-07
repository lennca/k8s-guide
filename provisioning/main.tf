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
    bastion_float   = module.bastion.bastion_float
    }
  )
  filename = "../configuration/ansible/hosts"
}

