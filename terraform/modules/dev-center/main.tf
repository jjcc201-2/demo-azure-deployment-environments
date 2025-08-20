# Dev Center
resource "azurerm_dev_center" "dev_center" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }
}

# Dev Center role assignments for subscription-level permissions
resource "azurerm_role_assignment" "dev_center_contributor" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = azurerm_dev_center.dev_center.identity[0].principal_id
}

# Dev Center role assignments for user access administrator
resource "azurerm_role_assignment" "dev_center_user_access_admin" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "User Access Administrator"
  principal_id         = azurerm_dev_center.dev_center.identity[0].principal_id
}

# Environment Types
resource "azurerm_dev_center_environment_type" "dev_center_env_sandbox" {
  name          = "Sandbox"
  dev_center_id = azurerm_dev_center.dev_center.id
  tags          = var.tags

}

resource "azurerm_dev_center_environment_type" "dev_center_env_dev" {
  name          = "Dev"
  dev_center_id = azurerm_dev_center.dev_center.id
  tags          = var.tags
}

resource "azurerm_dev_center_environment_type" "dev_center_env_test" {
  name          = "Test"
  dev_center_id = azurerm_dev_center.dev_center.id
  tags          = var.tags
}

resource "azurerm_dev_center_environment_type" "dev_center_env_prod" {
  name          = "Prod"
  dev_center_id = azurerm_dev_center.dev_center.id
  tags          = var.tags
}

# GitHub Catalog attached to Dev Center
resource "azurerm_dev_center_catalog" "dev_center_catalog" {
  name                = "dc_catalog"
  resource_group_name = var.resource_group_name
  dev_center_id       = azurerm_dev_center.dev_center.id

  catalog_github {
    branch            = "main"
    path              = "Environments"
    uri               = var.github_uri
    key_vault_key_url = var.github_pat_secret_id
  }
}

data "azurerm_client_config" "current" {}