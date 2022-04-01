## Overview

Deploy hosting environment with Terraform and configure it with Ansible through a bastion host. Nodes are deployed in form of regular VMs.

##### Deployment diagram

![Alt text](./diagram.jpg?raw=true "Title")

##### In many scenerios ['Image'](https://github.com/pkrakowski/WorldApp/tree/main/Deployments/VMs/image) based deployment strategy with VMSS may be preferable.


## Prerequisite

#### Create encrypted Ansible Vault file

For detailed guides on using Ansible Vault see https://docs.ansible.com/ansible/latest/user_guide/vault.html

- Create a key file for Ansible Vault.

Example:
```
openssl genrsa -out $HOME/.ansible_vault.key 2048
```
- Perpare Ansible Vault file

In */inventory/group_vars* directory you'll find a *ansible_vault.example.yaml*, rename it to *ansible_vault.yaml* and populate with your values. These are secret values that will be passed to resources on creation.

- Encrypt the file with Ansible Vault
```
ansible-vault encrypt <path to vars_ansible_vault.yaml> --vault-password-file <path to vault key>
```

#### Complete Terraform configuration

- Review default configuration in *variables.tf*.

- In *terraform.tfvars* provide:
```
#Resource Group to deploy to
resource_group_name =

#Region to delploy to
location =

#SSH public key path for VM access
ssh_public_key_path =

#Path to previously created Ansible Vault key file
vault_pass_file =
```
You can also override all the other defaults with terraform.tfvars.
E.g. By default, only one node for each service will be created. If you require more just add additional entries to the list following the naming scheme.

## Deployment

#### Infrastructure
To deploy, from *Terraform* directory run:
```
terraform apply
```
After the deployment has been completed you should see two new files created in the parent directory which will be used by Ansible.
1) */inventory/inventory.ini* - Inventory file containing IPs of all newly created instances with instruction for Ansible to connect to the nodes through a bastion host.
2) */inventory/group_vars/all.yaml* - Vars file containing required detail around created resources.

#### Configuration

To configure nodes, database and deploy app run:

```
ansible-playbook site.yaml --vault-password-file <path to .ansible_vault.key>
```






