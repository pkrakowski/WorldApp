resource "azurerm_redis_cache" "redis" {
  name                          = "worldappredis${random_string.random.result}-redis"
  location                      = var.location
  resource_group_name           = data.azurerm_resource_group.rg.name
  capacity                      = 0
  family                        = "C"
  sku_name                      = "Basic"
  enable_non_ssl_port           = false
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false

  redis_configuration {
  }
}


#Create Private Endpoint connection
resource "azurerm_private_dns_zone" "redispednszone" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "network_link_redis" {
  name                  = "redis_vnet_link"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.redispednszone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}


resource "azurerm_private_endpoint" "redispe" {
  name                = "worldapp${random_string.random.result}-redispe"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.privateendpointsubnet.id

  private_service_connection {
    name                           = "${random_string.random.result}-redispeconnection"
    private_connection_resource_id = azurerm_redis_cache.redis.id
    subresource_names              = [ "redisCache" ]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_a_record" "privatedns_redisentry" {
  name                = azurerm_redis_cache.redis.name
  zone_name           = azurerm_private_dns_zone.redispednszone.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.redispe.private_service_connection.0.private_ip_address]
    }