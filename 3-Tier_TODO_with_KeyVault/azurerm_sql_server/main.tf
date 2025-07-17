###TODO App SQL Server###
resource "azurerm_mssql_server" "sql_server" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.sql_serverversion
  administrator_login          = data.azurerm_key_vault_secret.sql_adminuser.value
  administrator_login_password = data.azurerm_key_vault_secret.sql_admin_pass.value
  #minimum_tls_version          = "12.0"
}

data "azurerm_key_vault" "keyvault" {
  name = var.keyvault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "sql_adminuser" {
  name = var.sql_adminuser
  key_vault_id = data.azurerm_key_vault.keyvault.id
  
}

data "azurerm_key_vault_secret" "sql_admin_pass" {
  name = var.sql_admin_pass
  key_vault_id = data.azurerm_key_vault.keyvault.id
  
}