
resource "azurerm_public_ip" "bastionnodeip" {
  name                = "BastionPublicIP"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "bastionnodenic" {
  name                = "BastionNIC"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "BastionNicConfiguration"
    subnet_id                     = azurerm_subnet.bastionnodesubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastionnodeip.id
  }
}

resource "azurerm_linux_virtual_machine" "bastionnode" {
  name                  = "BastionNode"
  location              = var.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.bastionnodenic.id]
  size                  = var.bastionnode_size

  os_disk {
    name                 = "BastionOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = var.ubuntu_release
    version   = "latest"
  }

  computer_name                   = "BastionNode"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(var.ssh_public_key_path)
  }

  identity {
    type = "SystemAssigned"
  }

}