variable "key_pair" {
  type        = string
  description = "Key pair name associated with CS Cloud"
}

variable "network_name" {
  type        = string
  description = "The name of the network"
}

variable "sec_groups" {
  type        = list(string)
  description = "List of security rules"
}