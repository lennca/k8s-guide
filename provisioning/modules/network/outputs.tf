output "network_name" {
  description = "The name of the network"
  value       = openstack_networking_network_v2.network.name
}

output "network_id" {
  description = "The name of the network"
  value       = openstack_networking_network_v2.network.id
}

output "vip_subnet_id" {
  value       = "${openstack_networking_subnet_v2.subnet.id}"
  description = "ID of subnet."
}
