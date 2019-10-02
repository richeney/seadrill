resource "azurerm_virtual_network_peering" "hub-spoke1" {
  name                      = "hub_to_spoke1"
  resource_group_name       = azurerm_resource_group.test.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke1.id

  allow_virtual_network_access  = true
  allow_forwarded_traffic       = false

  allow_gateway_transit         = false
  use_remote_gateways           = false
}

resource "azurerm_virtual_network_peering" "spoke1-hub" {
  name                      = "spoke1_to_hub"
  resource_group_name       = azurerm_resource_group.test.name
  virtual_network_name      = azurerm_virtual_network.spoke1.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id

  allow_virtual_network_access  = true
  allow_forwarded_traffic       = true

  allow_gateway_transit         = false
  use_remote_gateways           = false
}

resource "azurerm_virtual_network_peering" "hub-spoke2" {
  name                      = "hub_to_spoke2"
  resource_group_name       = azurerm_resource_group.test.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke2.id

  allow_virtual_network_access  = true
  allow_forwarded_traffic       = false

  allow_gateway_transit         = false
  use_remote_gateways           = false
}

resource "azurerm_virtual_network_peering" "spoke2-hub" {
  name                      = "spoke2_to_hub"
  resource_group_name       = azurerm_resource_group.test.name
  virtual_network_name      = azurerm_virtual_network.spoke2.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id

  allow_virtual_network_access  = true
  allow_forwarded_traffic       = true

  allow_gateway_transit         = false
  use_remote_gateways           = false
}