
resource "azurerm_network_interface" "clientnodenic" {
  for_each            = var.clientnodes
  name                = "${each.value}NIC"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${each.value}NicConfiguration"
    subnet_id                     = azurerm_subnet.clientnodesubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "clientnode" {
  for_each              = var.clientnodes
  name                  = each.value
  location              = var.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.clientnodenic[each.key].id]
  size                  = var.clientnode_size

  os_disk {
    name                 = "${each.value}OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = var.ubuntu_release
    version   = "latest"
  }

  computer_name                   = each.value
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