resource "azurerm_kubernetes_cluster" "aks" {
  name       = var.aks_name
  location   = data.azurerm_resource_group.rg.location
  dns_prefix = var.aks_dns_prefix

  resource_group_name = data.azurerm_resource_group.rg.name

  azure_policy_enabled = true

  default_node_pool {
    name            = "agentpool"
    node_count      = var.aks_agent_count
    vm_size         = var.aks_agent_vm_size
    os_disk_size_gb = var.aks_agent_os_disk_size
    vnet_subnet_id  = data.azurerm_subnet.kubesubnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = var.aks_dns_ip
    docker_bridge_cidr = var.aks_docker_bridge_cidr
    service_cidr       = var.aks_service_network_range
  }

  role_based_access_control {
    enabled = var.aks_enable_rbac
  }


  ingress_application_gateway {
    gateway_id = azurerm_application_gateway.appgw.id
  }


  depends_on = [azurerm_virtual_network.vnet, azurerm_application_gateway.appgw]
  tags       = var.tags
}

data "azurerm_user_assigned_identity" "ingress" {
  name                = "ingressapplicationgateway-${azurerm_kubernetes_cluster.aks.name}"
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group

  depends_on = [azurerm_kubernetes_cluster.aks]
}


resource "azurerm_role_assignment" "ingress" {
  scope                = azurerm_application_gateway.appgw.id
  role_definition_name = "Owner"
  principal_id         = data.azurerm_user_assigned_identity.ingress.principal_id

  depends_on = [azurerm_kubernetes_cluster.aks]
}