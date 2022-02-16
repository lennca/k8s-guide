variable "vip_subnet_id" {
  type = string
  description = "Id of subnet."
}

variable "address" {
  type = list(string)
  description = "Woker node ip addresses."
}

variable "sec_group_ids" {
  type = list(string)
  description = "Security group to be assigned load balancer."
}
