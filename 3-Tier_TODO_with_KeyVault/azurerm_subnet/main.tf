#Subnet Module for TODO Infra"

resource "azurerm_subnet" "todo_subnet" {
    name = var.name
    resource_group_name = var.resource_group_name
    virtual_network_name = var.virtual_network_name
    address_prefixes = var.address_prefixes
    
  
}
