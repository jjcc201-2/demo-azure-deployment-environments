resource "azurerm_dev_center_project" "project" {
  dev_center_id       = var.dev_center_id
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Assign role for Dev Project which enables usage of ADE
resource "azurerm_role_assignment" "dev_project_role_access" {
  scope                = azurerm_dev_center_project.project.id
  role_definition_name = "Deployment Environments User"
  principal_id         = var.developers_group_object_id
}

# Creation of environment types for dev projects
resource "azurerm_dev_center_project_environment_type" "dp_env_sandbox" {
  name                  = "Sandbox"
  location              = var.location
  dev_center_project_id = azurerm_dev_center_project.project.id
  deployment_target_id  = "/subscriptions/${var.subscription_id}"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_dev_center_project_environment_type" "dp_env_dev" {
  name                  = "Dev"
  location              = var.location
  dev_center_project_id = azurerm_dev_center_project.project.id
  deployment_target_id  = "/subscriptions/${var.subscription_id}"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_dev_center_project_environment_type" "dp_env_test" {
  name                  = "Test"
  location              = var.location
  dev_center_project_id = azurerm_dev_center_project.project.id
  deployment_target_id  = "/subscriptions/${var.subscription_id}"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_dev_center_project_environment_type" "dp_env_prod" {
  name                  = "Prod"
  location              = var.location
  dev_center_project_id = azurerm_dev_center_project.project.id
  deployment_target_id  = "/subscriptions/${var.subscription_id}"

  identity {
    type = "SystemAssigned"
  }
}
