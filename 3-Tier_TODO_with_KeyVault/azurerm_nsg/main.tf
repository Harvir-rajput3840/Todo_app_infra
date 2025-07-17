resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.nsg_location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "inbound-rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

data "azurerm_network_security_group" "nsg_assc" {
  name                = var.nsg_name
  resource_group_name = var.rg_name
}

data "azurerm_subnet" "subnet_data" {
  name                 = var.todo_subnet
  virtual_network_name = var.todo_vnet
  resource_group_name  = var.rg_name
}

resource "azurerm_subnet_network_security_group_association" "nsg_assc" {
  subnet_id                 = data.azurerm_subnet.subnet_data.id
  network_security_group_id = data.azurerm_network_security_group.nsg_assc.id
}


