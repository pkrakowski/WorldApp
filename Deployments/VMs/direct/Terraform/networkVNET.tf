#Create VNET
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = [var.vnet_address_space]
}

#Create Subnets

resource "azurerm_subnet" "appgwsubnet" {
  name                 = var.appgw_subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.appgw_subnet_range]
}


resource "azurerm_subnet" "clientnodesubnet" {
  name                 = var.clientnode_subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.clientnode_subnet_range]
}

resource "azurerm_subnet" "apinodesubnet" {
  name                 = var.apinode_subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.apinode_subnet_range]
}

resource "azurerm_subnet" "adminnodesubnet" {
  name                 = var.adminnode_subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.adminnode_subnet_range]
}

resource "azurerm_subnet" "privateendpointsubnet" {
  name                 = var.privateendpoint_subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.privateendpoint_subnet_range]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet" "bastionnodesubnet" {
  name                 = var.bastionnode_subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.bastionnode_subnet_range]
}


resource "azurerm_subnet_network_security_group_association" "clientnodensg_association" {
  subnet_id                 = azurerm_subnet.clientnodesubnet.id
  network_security_group_id = azurerm_network_security_group.clientnodensg.id
}

resource "azurerm_subnet_network_security_group_association" "apinodensg_association" {
  subnet_id                 = azurerm_subnet.apinodesubnet.id
  network_security_group_id = azurerm_network_security_group.apinodensg.id
}

resource "azurerm_subnet_network_security_group_association" "adminnodensg_association" {
  subnet_id                 = azurerm_subnet.adminnodesubnet.id
  network_security_group_id = azurerm_network_security_group.adminnodensg.id
}

resource "azurerm_subnet_network_security_group_association" "bastionnodensg_association" {
  subnet_id                 = azurerm_subnet.bastionnodesubnet.id
  network_security_group_id = azurerm_network_security_group.bastionnodensg.id
}


#Create NSGs
resource "azurerm_network_security_group" "clientnodensg" {
  name                = "clientnode-nsg"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "apinodensg" {
  name                = "apinode-nsg"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "adminnodensg" {
  name                = "adminnode-nsg"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "bastionnodensg" {
  name                = "bastionnode-nsg"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}