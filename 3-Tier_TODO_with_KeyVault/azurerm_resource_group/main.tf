####ToDo Application resource###

resource "azurerm_resource_group" "todo_rg1" {
  name     = var.name
  location = var.location
}