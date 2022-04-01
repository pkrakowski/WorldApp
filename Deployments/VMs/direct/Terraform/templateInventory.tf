
#Creates inventory file for Ansible
resource "local_file" "inventory" {
  content = templatefile("${path.module}/templates/inventory.ini.tftpl",
    {
      clientips = toset([for clientnode in azurerm_linux_virtual_machine.clientnode : clientnode.private_ip_address])
      apiips = toset([for apinode in azurerm_linux_virtual_machine.apinode : apinode.private_ip_address])
      adminips = toset([for adminnode in azurerm_linux_virtual_machine.adminnode : adminnode.private_ip_address])
      bastionip = azurerm_linux_virtual_machine.bastionnode.public_ip_address
      mysqlfqdn = azurerm_mysql_server.mysqlserver.fqdn
    }
  )
  filename = "../inventory/inventory.ini"
}