terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

# Load Balancer
resource "openstack_lb_loadbalancer_v2" "lb" {
  vip_subnet_id      = var.vip_subnet_id
  name               = "lb"
  security_group_ids = var.sec_group_ids
}


# Load Balancer pool
resource "openstack_lb_pool_v2" "pool" {
  name            = "lb_pool"
  protocol        = "HTTP"
  lb_method       = "ROUND_ROBIN"
  loadbalancer_id = openstack_lb_loadbalancer_v2.lb.id
}

# Load Balancer listener
resource "openstack_lb_listener_v2" "listener" {
  name            = "listener"
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = openstack_lb_loadbalancer_v2.lb.id
  default_pool_id = openstack_lb_pool_v2.pool.id
}

# Load Balancer monitor
resource "openstack_lb_monitor_v2" "monitor" {
  name        = "lb_monitor"
  pool_id     = openstack_lb_pool_v2.pool.id
  type        = "TCP"
  delay       = 5
  timeout     = 5
  max_retries = 3
}

# Members
resource "openstack_lb_member_v2" "member" {
  count         = length(var.address)
  address       = var.address[count.index]
  protocol_port = 30001
  pool_id       = openstack_lb_pool_v2.pool.id
  subnet_id     = var.vip_subnet_id
}

# Allocate floating ip
resource "openstack_networking_floatingip_v2" "floatip_1" {
  pool    = "public"
}

# Associate floating ip to load balancer
resource "openstack_networking_floatingip_associate_v2" "floatip_2" {
  floating_ip = openstack_networking_floatingip_v2.floatip_1.address
  port_id     = openstack_lb_loadbalancer_v2.lb.vip_port_id
}