resource "azurerm_mysql_server" "mysqlserver" {
  name                = "worldappdb${random_string.random.result}-mysql"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  sku_name = var.dbsku

  storage_profile {
    storage_mb            = var.dbstorage
    backup_retention_days = 7
    geo_redundant_backup  = "Enabled"
    auto_grow             = "Enabled"
  }

  administrator_login          = "mysqladmin"
  administrator_login_password = data.ansiblevault_path.mysql_root_password.value
  version                      = "5.7"
  ssl_enforcement              = "Disabled"
  public_network_access_enabled = false

  lifecycle {
    ignore_changes = [
      threat_detection_policy 
    ]
  }
}

#Create Private Endpoint connection
resource "azurerm_private_dns_zone" "mysqlpednszone" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "network_link_mysql" {
  name                  = "mysql_vnet_link"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.mysqlpednszone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_endpoint" "mysqlpe" {
  name                = "worldappdb${random_string.random.result}-mysqlpe"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.privateendpointsubnet.id

  private_service_connection {
    name                           = "${random_string.random.result}-mysqlpeconnection"
    private_connection_resource_id = azurerm_mysql_server.mysqlserver.id
    subresource_names              = [ "mysqlServer" ]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_a_record" "privatedns_mysqlentry" {
  name                = azurerm_mysql_server.mysqlserver.name
  zone_name           = azurerm_private_dns_zone.mysqlpednszone.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.mysqlpe.private_service_connection.0.private_ip_address]
}
