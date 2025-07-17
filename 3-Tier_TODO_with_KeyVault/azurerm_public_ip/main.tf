resource "azurerm_public_ip" "Public_IP" {
  name                = var.publicip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

