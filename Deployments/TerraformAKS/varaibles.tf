#RG and Region

variable "resource_group_name" {
  description = "Resource Group Name"
}

#VNET

variable "vnet_name" {
  description = "Virtual network name"
  default     = "aksVirtualNetwork"
}

variable "vnet_address_space" {
  description = "VNET address space"
  default     = "10.1.0.0/16"
}

variable "aks_subnet_name" {
  description = "AKS subnet Name"
  default     = "kubesubnet"
}

variable "aks_subnet_range" {
  description = "AKS subnet range"
  default     = "10.1.1.0/24"
}

#APPGW

variable "appgw_subnet_range" {
  description = "Application Gateway subnet range"
  default     = "10.1.2.0/24"
}


variable "appgw_name" {
  description = "Name of the Application Gateway"
  default     = "ApplicationGateway"
}

variable "appgw_sku" {
  description = "Name of the Application Gateway SKU"
  default     = "Standard_v2"
}

#AKS

variable "aks_name" {
  description = "AKS cluster name"
  default     = "aks-cluster"
}

variable "aks_service_network_range" {
  description = "IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges. For example: 10.0.0.0/16."
  default     = "10.0.0.0/16"
}

variable "aks_dns_ip" {
  description = "AKS DNS server IP address"
  default     = "10.0.0.10"
}

variable "aks_docker_bridge_cidr" {
  description = "CIDR notation IP for Docker bridge."
  default     = "172.17.0.1/16"
}

variable "aks_dns_prefix" {
  description = "Optional DNS prefix to use with hosted Kubernetes API server FQDN."
  default     = "aks"
}

variable "aks_agent_os_disk_size" {
  description = "Disk size (in GB) to provision for each of the agent pool clientnodes. This value ranges from 0 to 1023. Specifying 0 applies the default disk size for that agentVMSize."
  default     = 40
}

variable "aks_agent_count" {
  description = "The number of agent clientnodes for the cluster."
  default     = 1
}

variable "aks_agent_vm_size" {
  description = "VM size"
  default     = "standard_D2as_v4"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  default     = "1.11.5"
}

variable "aks_enable_rbac" {
  description = "Enable RBAC on the AKS cluster. Defaults to false."
  default     = "false"
}

variable "tags" {
  type = map(string)

  default = {
    source = "terraform"
  }
}
