terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

# SSH security group
resource "openstack_networking_secgroup_v2" "secgroup_ssh" {
  name        = var.ssh_name
  description = "SSH security group"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_ssh.id}"
}

# NodePort security group
resource "openstack_networking_secgroup_v2" "secgroup_nodeport" {
  name        = "secgroup_nodeport"
  description = "Kubernetes NodePort security group"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_nodeport" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 30001
  port_range_max    = 30001
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_nodeport.id
}

# HTTP security group
resource "openstack_networking_secgroup_v2" "secgroup_http" {
  name        = "secgroup_http"
  description = "HTTP security group"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_http.id
}
