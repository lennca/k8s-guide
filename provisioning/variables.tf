variable "auth_url" {
  type        = string
  description = "AUTH_URL from rc-file"
}

variable "username" {
  type        = string
  description = "CSCloud username"
}

variable "password" {
  type        = string
  description = "CSCloud password"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "CSCloud region"
}

variable "tenant_name" {
  type        = string
  description = "TENANT_NAME from rc-file"
}

variable "tenant_id" {
  type        = string
  description = "TENANT_ID from rc-file"
}

variable "external_network_id" {
  type        = string
  description = "External public network id from CS Cloud"
}

variable "instances" {
  description = "Number of woker nodes"
  type        = number
}

variable "ssh_name" {
  type        = string
  default     = "ssh"
  description = "Name for security rule ssh"
}

#needed?
variable "key_pair" {
  type      = string
  sensitive = true
}

variable "key_name" {
  type = string
}