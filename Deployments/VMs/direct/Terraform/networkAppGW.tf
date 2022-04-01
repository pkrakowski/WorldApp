locals {
  public_frontend_port_name       = "publicfeport"
  private_frontend_port_name      = "privatefeport"
  public_frontend_ip_configuration_name  = "public_ipconfig"
  private_frontend_ip_configuration_name  = "private_ipconfig"
  public_listener_name            = "PublicHttplistener"
  private_listener_name           = "PrivateHttplistener"
  url_path_map_name               = "pathmap"
}


resource "azurerm_public_ip" "appgwip" {
  name                = "applicationGatewayIP"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "appgw" {
  name                = "applicationGateway1"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location

  sku {
    name     = var.appgw_sku
    tier     = var.appgw_sku
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "gatewayipconfig"
    subnet_id = azurerm_subnet.appgwsubnet.id
  }

  frontend_ip_configuration {
    name                 = local.public_frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgwip.id
  }

  frontend_ip_configuration {
    name                 = local.private_frontend_ip_configuration_name
    subnet_id = azurerm_subnet.appgwsubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.1.0.100"
  }

  frontend_port {
    name = local.public_frontend_port_name
    port = 80
  }

  frontend_port {
    name = local.private_frontend_port_name
    port = 8080
  }

  backend_address_pool {
    name = "ClientNodes"
    ip_addresses = toset([for clientnode in azurerm_linux_virtual_machine.clientnode : clientnode.private_ip_address])
  }

  backend_address_pool {
    name = "ApiNodes"
    ip_addresses = toset([for apinode in azurerm_linux_virtual_machine.apinode : apinode.private_ip_address])
  }

  backend_address_pool {
    name = "AdminNodes"
    ip_addresses = toset([for adminnode in azurerm_linux_virtual_machine.adminnode : adminnode.private_ip_address])
  }

    probe {
    host = "127.0.0.1"
    interval = 30
    minimum_servers = 0
    name  = "healthprobe"
    path = "/health"
    pick_host_name_from_backend_http_settings = false
    protocol = "Http"
    timeout = 30
    unhealthy_threshold = 3

      match {
      status_code = [
        "200-399",
      ]
    }
  }

  backend_http_settings {
    name                  = "ClientHTTPSetting"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = "healthprobe"
  }

    backend_http_settings {
    name                  = "ApiHTTPSetting"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = "healthprobe"
  }

    backend_http_settings {
    name                  = "AdminHTTPSetting"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = "healthprobe"
  }


  http_listener {
    name                           = local.public_listener_name
    frontend_ip_configuration_name = local.public_frontend_ip_configuration_name
    frontend_port_name             = local.public_frontend_port_name
    protocol                       = "Http"
  }


    http_listener {
    name                           = local.private_listener_name
    frontend_ip_configuration_name = local.private_frontend_ip_configuration_name
    frontend_port_name             = local.private_frontend_port_name
    protocol                       = "Http"
  }


  request_routing_rule {
    name               = "NodesPublicRouting"
    rule_type          = "PathBasedRouting"
    url_path_map_name  = local.url_path_map_name
    http_listener_name = local.public_listener_name
  }

  request_routing_rule {
    name                       = "InternalAPIRouting"
    rule_type                  = "Basic"
    http_listener_name         = local.private_listener_name
    backend_address_pool_name  = "ApiNodes"
    backend_http_settings_name = "ApiHTTPSetting"
  }

  url_path_map {
      name                                    = local.url_path_map_name
      default_backend_address_pool_name       = "ClientNodes"
      default_backend_http_settings_name      = "ClientHTTPSetting"

      path_rule {
        name                                  = "apirule"
        backend_address_pool_name             = "ApiNodes"
        backend_http_settings_name            = "ApiHTTPSetting"
        paths = ["/api/*"]
      }
        path_rule {
        name                                  = "adminrule"
        backend_address_pool_name             = "AdminNodes"
        backend_http_settings_name            = "AdminHTTPSetting"
        paths = ["/admin/*"]
      }
  }
}