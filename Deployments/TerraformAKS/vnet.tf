resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = [var.vnet_address_space]

  subnet {
    name           = var.aks_subnet_name
    address_prefix = var.aks_subnet_range
  }

  subnet {
    name           = "appgwsubnet"
    address_prefix = var.appgw_subnet_range
  }

  tags = var.tags
}

data "azurerm_subnet" "kubesubnet" {
  name                 = var.aks_subnet_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
  depends_on           = [azurerm_virtual_network.vnet]
}

data "azurerm_subnet" "appgwsubnet" {
  name                 = "appgwsubnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
  depends_on           = [azurerm_virtual_network.vnet]
}
