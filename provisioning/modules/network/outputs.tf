output "network_name" {
  description = "The name of the network"
  value       = openstack_networking_network_v2.network.name
}