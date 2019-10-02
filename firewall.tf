resource "azurerm_public_ip" "fw" {
  name                = "${var.prefix}-fw-pip"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_log_analytics_workspace" "fw" {
  name                = "${var.prefix}-fw-logs"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  sku                 = "Free"
}

resource "azurerm_firewall" "fw" {
  name                = "${var.prefix}-fw"
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
  priority            = 65000
  action              = "Allow"

  rule {
    name = "permissive"
    source_addresses = [ "*", ]
    destination_ports = [ "*" ]
    destination_addresses = [ "*" ]
    protocols = [ "Any" ]
  }
}

resource "azurerm_firewall_nat_rule_collection" "test" {
  name                = "ssh_to_vm1"
  azure_firewall_name = "${azurerm_firewall.fw.name}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  priority            = 100
  action              = "Dnat"
  rule {
    name = "vm1"
    source_addresses        = [ "*" ]
    destination_addresses   = [ azurerm_public_ip.fw.ip_address ]
    destination_ports       = [ "22" ]
    translated_address      = "10.1.1.5"
    translated_port         = "22"
    protocols = [ "TCP" ]
  }
}

resource "azurerm_firewall_application_rule_collection" "test" {
  name                = "Blacklist"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_resource_group.test.name
  priority            = 100
  action              = "Deny"
  rule {
    name = "No Daily Mail for spoke2"
    source_addresses = [ "10.2.0.0/16" ]
    target_fqdns = [ "*.dailymail.co.uk" ]
    protocol {
      port = "443"
      type = "Https"
    }
  }
}
