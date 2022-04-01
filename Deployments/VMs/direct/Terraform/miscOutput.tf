output "clientnodes_ip" {
  value = {
    for clientnode_key, clientnode_data in azurerm_linux_virtual_machine.clientnode : clientnode_key => clientnode_data.private_ip_address
  }
}

output "apinodes_ip" {
  value = {
    for apinode_key, apinode_data in azurerm_linux_virtual_machine.apinode : apinode_key => apinode_data.private_ip_address
  }
}

output "adminnodes_ip" {
  value = {
    for adminnode_key, adminnode_data in azurerm_linux_virtual_machine.adminnode : adminnode_key => adminnode_data.private_ip_address
  }
}

output "mysql_hostname" {
  value = azurerm_mysql_server.mysqlserver.fqdn
}

