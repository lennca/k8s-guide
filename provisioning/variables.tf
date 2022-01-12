variable "auth_url" {
  type        = string
  description = "AUTH_URL from rc-file"
}

variable "user_name" {
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

#needed?
variable "key_pair" {
  type      = string
  sensitive = true
}

variable "key_name" {
  type = string
}