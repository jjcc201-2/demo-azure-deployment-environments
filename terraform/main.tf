data "azurerm_client_config" "current" {}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.rg_name}-${random_id.rg_name.hex}"
  location = var.location
  tags     = local.common_tags
}

# Create an Entra security group which will have access to one of the dev projects
resource "azuread_group" "entra-sg" {
  display_name     = "sg-ade-developers-${random_id.rg_name.hex}"
  owners           = [data.azurerm_client_config.current.object_id]
  security_enabled = true
}

# Add current user to the security group 
resource "azuread_group_member" "entra-user" {
  group_object_id  = azuread_group.entra-sg.object_id
  member_object_id = data.azurerm_client_config.current.object_id
}

# Add optional additional users to the security group
resource "azuread_group_member" "dev_users" {
  for_each = toset(local.user_object_ids)

  group_object_id  = azuread_group.entra-sg.object_id
  member_object_id = each.value
}


module "dev_center" {
  source = "./modules/dev-center"

  name                 = "devcenter-${random_id.rg_name.hex}"
  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  tags                 = local.common_tags # Pass the tags from locals
  github_uri           = var.github_uri
  github_pat_secret_id = module.key_vault.github_pat_secret_id
  github_path          = var.github_path
}

module "dev_project" {
  source                     = "./modules/dev-project"
  name                       = "dev-project-${random_id.rg_name.hex}"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  tags                       = local.common_tags
  dev_center_id              = module.dev_center.dev_center_id
  subscription_id            = data.azurerm_client_config.current.subscription_id
  developers_group_object_id = azuread_group.entra-sg.object_id
}


module "key_vault" {
  source = "./modules/key-vault"

  name                    = "${var.kv_name}${random_id.rg_name.hex}"
  location                = var.location
  resource_group_name     = azurerm_resource_group.rg.name
  tags                    = local.common_tags
  github_pat              = var.github_pat
  tenant_id               = data.azurerm_client_config.current.tenant_id
  dev_center_principal_id = module.dev_center.identity_principal_id
  current_user_object_id  = data.azurerm_client_config.current.object_id
}



