output "master_ip" {
  description = "The IPv4 of the master"
  value       = openstack_compute_instance_v2.master.access_ip_v4
}

output "master_name" {
  description = "The master DNS name"
  value       = openstack_compute_instance_v2.master.name
}

output "worker_ip" {
  description = "The IPv4 of the workers"
  value       = slice([for index in openstack_compute_instance_v2.worker : index.access_ip_v4], 0, var.instances)
}

output "worker_name" {
  description = "The workers DNS name"
  value       = slice([for index in openstack_compute_instance_v2.worker : index.name], 0, var.instances)
}
