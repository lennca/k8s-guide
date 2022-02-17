# K8s-cluster in OpenStack

Kubernetes setup using Terraform, Ansible and OpenStack.

# About

Terraform deploy the environment including:
* Bastion
* K8s master
* K8s workers
* Openstack Load Balancer
* Required security groups
* Ansible inventory file
* Ansible config file

#### Bastion Overview
![Bastion overview](/documents/drawio/png/bastion.png)

#### Terraform Openstack Environment Overview
![Terraform Openstack environment overview](/documents/drawio/png/terraform_openstack.png)

# Getting Started

## Prerequisites

Ensure that you have the following installed:

* Terraform >= v1.1.5
* Ansible >= 2.9.27

## Run Terraform

1. Locate the directory `/provisioning`.

```
  cd /provisioning
```

2. Run Terraform and enter input when prompted.

##### Note: Enter `yes` to run Ansible automatically when prompted for.

```
  terraform apply --auto-approve
```

## Run Ansible manually

Ensure that Terraform is finished and that the files `hosts` and `ansible.cfg` exists in the directory `/configuration`.

1. Locate the directory `/configuration`

```
  cd /configuration
```

2. Run Ansible playbook.

```
  ansible-playbook -i hosts main.yaml
```


## Articles/documentation worth reading:

#### Terraform
* [Templatefile](https://www.terraform.io/language/functions/templatefile)

#### Ansible
* [Speed up Ansible](https://www.linkedin.com/pulse/how-speed-up-ansible-playbooks-drastically-lionel-gurret)

#### Others
* [Nginx template file](https://github.com/docker-library/docs/tree/master/nginx#using-environment-variables-in-nginx-configuration-new-in-119)