output "lb_public_ip" {
  value       = openstack_networking_floatingip_associate_v2.floatip_2.floating_ip
  description = "The float IP of the loadbalancer."
}
