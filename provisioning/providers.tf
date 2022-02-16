terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}
provider "openstack" {
  user_name   = "cl223mf-2dv517"
  tenant_name = var.tenant_name
  password    = var.password
  auth_url    = "https://cscloud.lnu.se:5000/v3"
  region      = "RegionOne"
  domain_name = "Default"
/*   endpoint_overrides = {
    "compute": "https://cscloud.lnu.se:8774/v2.1/",
    "container-infra": "https://cscloud.lnu.se:9511/",
    "identity": " https://cscloud.lnu.se:5000/",
    "image": " https://cscloud.lnu.se:9292/",
    "network": "https://cscloud.lnu.se:9696/",
    "volume": "https://cscloud.lnu.se:8776/v1/86d2f02a6acd4284b63c2ad5f4341de6/",
    "volume2": "https://cscloud.lnu.se:8776/v2/86d2f02a6acd4284b63c2ad5f4341de6/",
    "volume3": "https://cscloud.lnu.se:8776/v3/86d2f02a6acd4284b63c2ad5f4341de6/"
  } */
}