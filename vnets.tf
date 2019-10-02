provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.34.0"
}

# Create a resource group
resource "azurerm_resource_group" "test" {
  name     = var.resource_group
  location = "West Europe"
}

# Hub
resource "azurerm_virtual_network" "hub" {
  name                = "${var.prefix}-hub"
  address_space       = [ "10.0.0.0/16" ]
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_subnet" "hub-sn1" {
  name                 = "${var.prefix}-hub-subnet1"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_subnet" "fw" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = "${azurerm_resource_group.test.name}"
  virtual_network_name = "${azurerm_virtual_network.hub.name}"
  address_prefix       = "10.0.99.0/24"
}

# Spoke 1
resource "azurerm_virtual_network" "spoke1" {
  name                = "${var.prefix}-spoke1"
  address_space       = [ "10.1.0.0/16" ]
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_subnet" "spoke1-sn1" {
  name                 = "${var.prefix}-spoke1-subnet1"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.spoke1.name
  address_prefix       = "10.1.1.0/24"
  route_table_id       = azurerm_route_table.fw.id
}

# Spoke 2
resource "azurerm_virtual_network" "spoke2" {
  name                = "${var.prefix}-spoke2"
  address_space       = [ "10.2.0.0/16" ]
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_subnet" "spoke2-sn1" {
  name                 = "${var.prefix}-spoke2-subnet1"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.spoke2.name
  address_prefix       = "10.2.1.0/24"
  route_table_id       = azurerm_route_table.fw.id
}
