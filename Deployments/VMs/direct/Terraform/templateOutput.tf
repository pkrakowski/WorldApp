
#Creates output file for Ansible
resource "local_file" "vars_mysql" {
  content = templatefile("${path.module}/templates/all.yaml.tftpl",
    {
      mysql_host = azurerm_mysql_server.mysqlserver.fqdn
      mysql_root_user = "${azurerm_mysql_server.mysqlserver.administrator_login}@${azurerm_mysql_server.mysqlserver.name}"
      mysql_servername = azurerm_mysql_server.mysqlserver.name
      appgw_private_ip = azurerm_application_gateway.appgw.frontend_ip_configuration[1].private_ip_address
      appgw_private_port = tolist(azurerm_application_gateway.appgw.frontend_port)[0].port
      appgw_public_ip = azurerm_public_ip.appgwip.ip_address
      redis_url = "rediss://user:${nonsensitive(azurerm_redis_cache.redis.primary_access_key)}@${azurerm_redis_cache.redis.hostname}:6380/0"
    }
  )
  filename = "../inventory/group_vars/all.yaml"
}