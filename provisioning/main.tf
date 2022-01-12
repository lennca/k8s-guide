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