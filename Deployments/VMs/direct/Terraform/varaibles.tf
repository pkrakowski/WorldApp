#MISC

variable "vault_pass_file" {
  description = "Password to Ansible Vault file"
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key"
}

variable "ubuntu_release" {
  description = "Unbuntu release version"
  default = "20_04-lts-gen2"
}

#RG and Region

variable "resource_group_name" {
  description = "Resource Group Name"
}

variable "location" {
  description = "Region"
}

#APPGW

variable "appgw_sku" {
  description = "AppGW SKU"
  default     = "Standard_v2"
}

#CLIENT NODES

variable "clientnode_size" {
  description = "clientnodes size"
  default     = "Standard_B1s"
}

variable "clientnodes" {
  description = "Client Node names"
  type        = set(string)
  default     = ["clientnode1"]
}

#API NODES

variable "apinode_size" {
  description = "apinodes size"
  default     = "Standard_B1s"
}

variable "apinodes" {
  description = "API Node names"
  type        = set(string)
  default     = ["apinode1"]
}

#ADMIN NODES

variable "adminnode_size" {
  description = "adminnodes size"
  default     = "Standard_B1s"
}

variable "adminnodes" {
  description = "Node names"
  type        = set(string)
  default     = ["adminnode1"]
}


#BASTION NODES

variable "bastionnode_size" {
  description = "adminnodes size"
  default     = "Standard_B1s"
}

#MYSQL

variable "dbsku" {
  description = "Mysql Database SKU"
  default     = "GP_Gen5_2"
}

variable "dbstorage" {
  description = "Mysql Database storage capacity"
  default     = 10240
}

variable "databasename" {
  description = "New database name"
  default     = "world"
}

#VNET

variable "vnet_name" {
  description = "Virtual network name"
  default     = "asnibleVirtualNetwork"
}

variable "vnet_address_space" {
  description = "VNET address space"
  default     = "10.1.0.0/16"
}

variable "appgw_subnet_name" {
  description = "appgw subnet name"
  default     = "appgw"
}

variable "appgw_subnet_range" {
  description = "appgw subnet range"
  default     = "10.1.0.0/24"
}

variable "clientnode_subnet_name" {
  description = "clientnodes subnet name"
  default     = "clientnodes"
}

variable "clientnode_subnet_range" {
  description = "clientnodes subnet range"
  default     = "10.1.1.0/24"
}

variable "apinode_subnet_name" {
  description = "apinodes subnet name"
  default     = "apinodes"
}

variable "apinode_subnet_range" {
  description = "apinodes subnet range"
  default     = "10.1.2.0/24"
}

variable "adminnode_subnet_name" {
  description = "adminnodes subnet name"
  default     = "adminnodes"
}

variable "adminnode_subnet_range" {
  description = "adminnodes subnet range"
  default     = "10.1.3.0/24"
}

variable "privateendpoint_subnet_name" {
  description = "privateendpoints subnet name"
  default     = "privateendpoints"
}

variable "privateendpoint_subnet_range" {
  description = "privateendpoints subnet range"
  default     = "10.1.99.0/24"
}


variable "bastionnode_subnet_name" {
  description = "bastionnodes subnet name"
  default     = "bastionnodes"
}

variable "bastionnode_subnet_range" {
  description = "bastionnodes subnet range"
  default     = "10.1.100.0/24"
}



