##Main Parent Module for TO_DO Infra###

module "resource_group" { ##Resource Group Moudule
  source   = "../../azurerm_resource_group"
  name     = var.resource_group_name
  location = var.location
}

module "storage_account" { ##Storage Account Moudule
  depends_on          = [module.resource_group]
  source              = "../../azurerm_storage_account"
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "virtual_network" { ##Virtaul Network Moudule
  depends_on          = [module.resource_group]
  source              = "../../azurerm_virtual_network"
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
}

module "frontend-subnet" { ##Frontend Subnet Moudule
  depends_on           = [module.virtual_network]
  source               = "../../azurerm_subnet"
  name                 = var.frontend_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
  address_prefixes     = var.front_address_prefixes
}

module "backend-subnet" { ##Backend Subnet Moudule
  depends_on           = [module.virtual_network]
  source               = "../../azurerm_subnet"
  name                 = var.backend_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
  address_prefixes     = var.back_address_prefixes
}

module "frontend_Public_IP" { ##Frontend Public IP Module
  depends_on          = [module.resource_group]
  source              = "../../azurerm_public_ip"
  publicip_name       = var.frontend_publicip
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "backend_Public_IP" { ##Backend Public IP Module
  depends_on          = [module.resource_group]
  source              = "../../azurerm_public_ip"
  publicip_name       = var.backend_publicip
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "keyvault" { ##KeyVault Module
  depends_on          = [module.resource_group]
  source              = "../../azurerm_keyvault"
  keyvault_name       = var.keyvault_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "vault_user_secret" { ##User Keyvault
  depends_on          = [module.keyvault]
  source              = "../../azurerm_keyvault_secert"
  user_secret         = var.admin_user_secret
  pass_secret         = var.admin_pass_secret
  username            = var.username
  password            = var.password
  keyvault_name       = var.keyvault_name
  resource_group_name = var.resource_group_name
}


module "frontend_vm" { ##Frontend Virtual Machine Module 
  depends_on          = [module.frontend-subnet, module.frontend_Public_IP, module.keyvault, ]
  source              = "../../azurerm_virtual_machine"
  name                = var.frontend_vm_name
  vm_size             = var.vm_size
  nic_name            = var.frontend_nic_name
  resource_group_name = var.resource_group_name
  location            = var.location
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  image_publisher     = var.image_publisher
  image_offer         = var.image_offer
  Image_sku           = var.Image_sku
  Image_version       = var.Image_version
  public_ip_name      = var.frontend_publicip
  subnet_name         = var.frontend_subnet_name
  vnet                = var.vnet_name
  keyvault            = var.keyvault_name

}

module "backend_vm" { ##Backend Virtual Machine Module 
  depends_on          = [module.backend-subnet, module.backend_Public_IP, module.keyvault, ]
  source              = "../../azurerm_virtual_machine"
  name                = var.backend_vm_name
  vm_size             = var.vm_size
  nic_name            = var.backend_nic_name
  resource_group_name = var.resource_group_name
  location            = var.location
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  image_publisher     = var.image_publisher
  image_offer         = var.image_offer
  Image_sku           = var.Image_sku
  Image_version       = var.Image_version
  public_ip_name      = var.backend_publicip
  subnet_name         = var.backend_subnet_name
  vnet                = var.vnet_name
  keyvault            = var.keyvault_name

}

module "sql_server" { ##SQL Server Module
  depends_on          = [module.resource_group]
  source              = "../../azurerm_sql_server"
  name                = var.sql_server_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sql_adminuser       = var.sql_adminuser
  sql_admin_pass      = var.sql_admin_pass
  sql_serverversion   = var.sql_serverversion
  keyvault_name       = var.keyvault_name
}

module "sql_database" { ##SQL Database Module
  depends_on          = [module.sql_server, module.resource_group]
  source              = "../../azurerm_sql_database"
  sql_db_name         = var.sql_db_name
  sql_server_name     = var.sql_server_name
  resource_group_name = var.resource_group_name
}

# module "nsg" {                                       ##NSG Module
#     depends_on = [ module.frontend_vm ]
#     source = "../../azurerm_nsg"
#     nsg_name = "front-nsg"
#     nsg_location = "East US"
#     rg_name = "azdevtodo-rg"
#     todo_subnet = "azdevfront-subnet"
#     todo_vnet = "vm-vnet-todo"
# }

# module "nsg_assoc" {                               ##NSG Association
#     depends_on = [ module.nsg ]
#     source = "../../azurerm_nsg"
#     nsg_name = "front-nsg"
#     nsg_location = "East US"
#     rg_name = "azdevtodo-rg"
#     todo_subnet = "azdevfront-subnet"
#     todo_vnet = "vm-vnet-todo"
# }
