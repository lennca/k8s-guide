terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.46.0"
    }
  }
}

#Master node
resource "openstack_compute_instance_v2" "master" {
  name              = "master"
  image_id          = "ca4bec1a-ac25-434f-b14c-ad8078ccf39f" #Ubuntu server 20.04 
  flavor_name       = "c2-r2-d20"
  key_pair          = var.key_pair
  security_groups   = ["default"]
  availability_zone = "Education"

  network {
    name = var.network_name
  }
}

#Worker nodes
resource "openstack_compute_instance_v2" "worker" {
  count             = var.instances
  name              = var.instance_names[count.index]
  image_id          = "ca4bec1a-ac25-434f-b14c-ad8078ccf39f" #Ubuntu server 20.04 
  flavor_name       = "c2-r2-d20"
  key_pair          = var.key_pair
  security_groups   = ["default"]
  availability_zone = "Education"

  network {
    name = var.network_name
  }
}
