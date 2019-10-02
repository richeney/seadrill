resource "azurerm_public_ip" "fw" {
  name                = "fw"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_log_analytics_workspace" "fw" {
  name                = "seadrill-fw-logs"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  sku                 = "Free"
}

resource "azurerm_firewall" "fw" {
  name                = "seadrill-fw"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  ip_configuration {
    name                 = "fw"
    subnet_id            = azurerm_subnet.fw.id
    public_ip_address_id = azurerm_public_ip.fw.id
  }
}

resource "azurerm_firewall_network_rule_collection" "allow_everything" {
  name                = "Permissive"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_resource_group.test.name
  priority            = 999
  action              = "Allow"

  rule {
    name = "permissive"
    source_addresses = [ "*", ]
    destination_ports = [ "*" ]
    destination_addresses = [ "*" ]
    protocols = [ "Any" ]
  }
}

## resource "azurerm_firewall_network_rule_collection" "googledns" {
##   name                = "GoogleDNS"
##   azure_firewall_name = azurerm_firewall.fw.name
##   resource_group_name = azurerm_resource_group.test.name
##   priority            = 100
##   action              = "Deny"
##
##   rule {
##     name = "DenyGoogleDNS"
##     source_addresses = [ "10.1.0.0/16", "10.2.0.0/16" ]
##     destination_ports = [ "53" ]
##     destination_addresses = [ "8.8.8.8", "8.8.4.4" ]
##     protocols = [ "TCP", "UDP" ]
##   }
## }
##
## resource "azurerm_firewall_network_rule_collection" "cloudflare" {
##   name                = "CloudFlare"
##   azure_firewall_name = azurerm_firewall.fw.name
##   resource_group_name = azurerm_resource_group.test.name
##   priority            = 200
##   action              = "Allow"
##
##   rule {
##     name = "AllowCloudFlare"
##     source_addresses = [ "10.1.0.0/16", "10.2.0.0/16" ]
##     destination_ports = [ "53" ]
##     destination_addresses = [ "1.1.1.1", "1.0.0.1" ]
##     protocols = [ "TCP", "UDP" ]
##   }
## }
##
## resource "azurerm_firewall_nat_rule_collection" "test" {
##   name                = "testcollection"
##   azure_firewall_name = "${azurerm_firewall.fw.name}"
##   resource_group_name = "${azurerm_resource_group.test.name}"
##   priority            = 100
##   action              = "Dnat"
##
##   rule {
##     name = "DNS"
##     source_addresses        = [ "10.1.0.0/16", "10.2.0.0/16" ]
##     destination_addresses   = [ azurerm_public_ip.fw.ip_address ]
##     destination_ports       = [ "53" ]
##     translated_address      = "1.1.1.1"
##     translated_port         = "53"
##     protocols = [ "TCP", "UDP" ]
##   }
## }
##
## resource "azurerm_firewall_application_rule_collection" "test" {
##   name                = "testcollection"
##   azure_firewall_name = azurerm_firewall.fw.name
##   resource_group_name = azurerm_resource_group.test.name
##   priority            = 100
##   action              = "Allow"
##
##   rule {
##     name = "AllowSpokesToGoogle"
##     source_addresses = [ "10.1.0.0/16", "10.2.0.0/16" ]
##     target_fqdns = [ "*.google.com" ]
##     protocol {
##       port = "443"
##       type = "Https"
##     }
##   }
## }
##