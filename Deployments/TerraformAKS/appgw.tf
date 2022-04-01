resource "azurerm_public_ip" "publicip" {
  name                = "AppGwPublicIp"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_application_gateway" "appgw" {
  name                = var.appgw_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  sku {
    name     = var.appgw_sku
    tier     = var.appgw_sku
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "AppGwIpConfig"
    subnet_id = data.azurerm_subnet.appgwsubnet.id
  }

  frontend_port {
    name = "agicamanages"
    port = 80
  }

  #frontend_port {
  #name = "agicamanages"
  #port = 443
  #}

  frontend_ip_configuration {
    name                 = "frontendip"
    public_ip_address_id = azurerm_public_ip.publicip.id
  }

  backend_address_pool {
    name = "agicamanages"
  }

  backend_http_settings {
    name                  = "agicamanages"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = "agicamanages"
    frontend_ip_configuration_name = "frontendip"
    frontend_port_name             = "agicamanages"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "agicamanages"
    rule_type                  = "Basic"
    http_listener_name         = "agicamanages"
    backend_address_pool_name  = "agicamanages"
    backend_http_settings_name = "agicamanages"
  }

  #Prevents Terraform from overwriting changes deployed by AGIC
  lifecycle {
    ignore_changes = [
      backend_address_pool,
      backend_http_settings,
      frontend_port,
      http_listener,
      probe,
      redirect_configuration,
      request_routing_rule,
      ssl_certificate,
      tags,
      url_path_map,
    ]
  }


  tags       = var.tags
  depends_on = [azurerm_virtual_network.vnet, azurerm_public_ip.publicip]
}