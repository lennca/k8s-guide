output "sec_group_ids" {
  value       = tolist([openstack_networking_secgroup_rule_v2.secgroup_rule_http.security_group_id])
  description = "Security group id."
}

output "secgroup_nodeport" {
  value       = openstack_networking_secgroup_v2.secgroup_nodeport.name
  description = "Proxy port security group."
}
