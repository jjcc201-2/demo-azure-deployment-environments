data "azurerm_client_config" "current" {}


// Create an Entra security group which will have access to one of the dev projects
resource "azuread_group" "entra-sg" {
  display_name     = "sg-ade-developers-${random_id.rg_name.hex}"
  owners           = [data.azurerm_client_config.current.object_id]
  security_enabled = true
}


resource "azurerm_resource_group" "rg" {
  name     = "${var.rg_name}-${random_id.rg_name.hex}"
  location = var.location
  tags     = local.common_tags
}


// Creation of a dev center
// Contributor role access and User Access Administrator access to the dev center, needed for on-behalf-of user resource provisioning
// Key Vault 
resource "azurerm_dev_center" "dev_center" {
  location            = azurerm_resource_group.rg.location
  name                = "devcenter-${random_id.rg_name.hex}"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.common_tags
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "dev_center_contributor" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azurerm_dev_center.dev_center.identity[0].principal_id
}

resource "azurerm_role_assignment" "dev_center_user_access_admin" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "User Access Administrator"
  principal_id         = azurerm_dev_center.dev_center.identity[0].principal_id
}

// Creation of dev environment types 
resource "azurerm_dev_center_environment_type" "dev_center_env_sandbox" {
  name          = "Sandbox"
  dev_center_id = azurerm_dev_center.dev_center.id
  tags          = local.common_tags

}

resource "azurerm_dev_center_environment_type" "dev_center_env_dev" {
  name          = "Dev"
  dev_center_id = azurerm_dev_center.dev_center.id
  tags          = local.common_tags
}

resource "azurerm_dev_center_environment_type" "dev_center_env_test" {
  name          = "Test"
  dev_center_id = azurerm_dev_center.dev_center.id
  tags          = local.common_tags
}

resource "azurerm_dev_center_environment_type" "dev_center_env_prod" {
  name          = "Prod"
  dev_center_id = azurerm_dev_center.dev_center.id
  tags          = local.common_tags
}

resource "azurerm_dev_center_catalog" "dev_center_catalog" {
  name                = "dc_catalog"
  resource_group_name = azurerm_resource_group.rg.name
  dev_center_id       = azurerm_dev_center.dev_center.id
  catalog_github {
    branch            = "main"
    path              = "Environments"
    uri               = var.github_uri
    key_vault_key_url = azurerm_key_vault_secret.github_pat.id
  }
}

// Creation of multiple dev projects and the corresponding environment types

resource "azurerm_dev_center_project" "project" {
  dev_center_id       = azurerm_dev_center.dev_center.id
  location            = azurerm_resource_group.rg.location
  name                = "dev-project-${random_id.rg_name.hex}"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.common_tags

  depends_on = [azurerm_dev_center_environment_type.dev_center_env_dev,
    azurerm_dev_center_environment_type.dev_center_env_test,
    azurerm_dev_center_environment_type.dev_center_env_sandbox,
    azurerm_dev_center_environment_type.dev_center_env_prod
  ]
}

resource "azurerm_role_assignment" "dev_project_role_access" {
  scope                = azurerm_dev_center_project.project-a.id
  role_definition_name = "Deployment Environments User"
  principal_id         = azuread_group.entra-sg.object_id
}

resource "azurerm_dev_center_project_environment_type" "dp_env_sandbox" {
  name                  = "Sandbox"
  location              = azurerm_resource_group.rg.location
  dev_center_project_id = azurerm_dev_center_project.project-a.id
  deployment_target_id  = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_dev_center_project_environment_type" "dp_env_dev" {
  name                  = "Dev"
  location              = azurerm_resource_group.rg.location
  dev_center_project_id = azurerm_dev_center_project.project-a.id
  deployment_target_id  = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_dev_center_project_environment_type" "dp_env_test" {
  name                  = "Test"
  location              = azurerm_resource_group.rg.location
  dev_center_project_id = azurerm_dev_center_project.project-a.id
  deployment_target_id  = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"

  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_dev_center_project_environment_type" "dp_env_prod" {
  name                  = "Prod"
  location              = azurerm_resource_group.rg.location
  dev_center_project_id = azurerm_dev_center_project.project-a.id
  deployment_target_id  = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"

  identity {
    type = "SystemAssigned"
  }
}

// Creation of a Key Vault to host our GitHub PATs, with an access policy to the dev center so it can access PATs from our GitHub Catalog
resource "azurerm_key_vault" "kv" {
  name                     = "${var.kv_name}${random_id.rg_name.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = true
  tags                     = local.common_tags
}


// Two access policies in keyvault. 1 for the devcenter and another for the current user so they can add and view the GitHub PAT
resource "azurerm_key_vault_access_policy" "kv-ap-devcenter" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_dev_center.dev_center.identity[0].principal_id

  secret_permissions = ["Get", "List"]
}

resource "azurerm_key_vault_access_policy" "kv-ap-user" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = ["Get", "Set", "List", "Delete"]
}


resource "azurerm_key_vault_secret" "github_pat" {
  name         = "PAT-gh-ade"
  value        = var.github_pat
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_key_vault_access_policy.kv-ap-user]
}