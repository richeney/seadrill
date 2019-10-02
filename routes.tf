resource "azurerm_route_table" "fw" {
  name                = "route_to_fw"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_route" "fw" {
  name                   = "default_route_to_fw"
  resource_group_name    = azurerm_resource_group.test.name
  route_table_name       = azurerm_route_table.fw.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.fw.ip_configuration[0].private_ip_address
}

resource "azurerm_subnet_route_table_association" "spoke1-sn1_fw" {
  subnet_id      = "${azurerm_subnet.spoke1-sn1.id}"
  route_table_id = "${azurerm_route_table.fw.id}"
}
resource "azurerm_subnet_route_table_association" "spoke2-sn1_fw" {
  subnet_id      = "${azurerm_subnet.spoke2-sn1.id}"
  route_table_id = "${azurerm_route_table.fw.id}"
}
