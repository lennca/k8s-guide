output "bastion_float" {
  description = "The float IP of the bastion"
  value       = openstack_networking_floatingip_v2.floatip.address
}

output "bastion_ip" {
  description = "The IPv4 of the bastion"
  value       = openstack_compute_instance_v2.bastion.access_ip_v4
}

output "bastion_name" {
  description = "The bastion DNS name"
  value       = openstack_compute_instance_v2.bastion.name
}