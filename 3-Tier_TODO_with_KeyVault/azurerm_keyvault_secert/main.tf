data "azurerm_key_vault" "keyvault" {
    name = var.keyvault_name
    resource_group_name = var.resource_group_name
  
}

resource "azurerm_key_vault_secret" "admin_user_secret" {
  name         = var.admin_user_secret
  value        = var.username
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

resource "azurerm_key_vault_secret" "admin_pass_secret" {
  name         = var.admin_pass_secret
  value        = var.password
  key_vault_id = data.azurerm_key_vault.keyvault.id
}



