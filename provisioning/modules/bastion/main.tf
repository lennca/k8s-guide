terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.46.0"
    }
  }
}

resource "openstack_compute_instance_v2" "bastion" {
  name              = "bastion"
  image_id          = "ca4bec1a-ac25-434f-b14c-ad8078ccf39f" #Ubuntu server 20.04 
  flavor_name       = "c2-r2-d20"
  key_pair          = var.key_pair
  security_groups   = ["default"]
  availability_zone = "Education"

  network {
    name = var.network_name
  }
}

#Allocate float IP
resource "openstack_networking_floatingip_v2" "floatip" {
  pool = "public"
}

#Associate float IP to instance
resource "openstack_compute_floatingip_associate_v2" "floatip_ass" {
  floating_ip = "${openstack_networking_floatingip_v2.floatip.address}"
  instance_id = "${openstack_compute_instance_v2.bastion.id}"
}
