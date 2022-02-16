variable "key_pair" {
  type        = string
  description = "Key pair name associated with CS Cloud"
}

variable "network_name" {
  type        = string
  description = "The name of the network"
}

variable "instances" {
  description = "Number of worker nodes"
  type        = number
  default     = 2

  validation {
    condition     = contains([1, 2, 3, 4, 5], var.instances)
    error_message = "Valid number of instances (1...5)."
  }
}

variable "instance_names" {
  type    = list(string)
  default = ["worker-1", "worker-2", "worker-3", "worker-4", "worker-5"]
}

variable "secgroup_nodeport" {
  type = string
}
