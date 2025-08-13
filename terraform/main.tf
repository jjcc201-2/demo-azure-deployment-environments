data "azurerm_client_config" "current" {}

// Create random ID for resource group, environment, log analytics workspace and container name
resource "random_id" "rg_name" {
  byte_length = 4
}


# Azure resource group resource
resource "azurerm_resource_group" "rg" {
  name     = "${var.rg_name}-${random_id.rg_name.hex}"
  location = var.location
  tags = {
    environment   = "${var.environment}"
    purpose       = "${var.purpose}"
    instantiation = "${var.instantiation}"
  }
}

resource "azurerm_dev_center" "dev_center" {
  location            = azurerm_resource_group.rg.location
  name                = "devcenter-${random_id.rg_name.hex}"
  resource_group_name = azurerm_resource_group.rg.name
  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_dev_center_environment_type" "dev_center_env_sandbox" {
  name          = "Sandbox"
  dev_center_id = azurerm_dev_center.dev_center.id

  tags = {
    environment   = "Sandbox"
    purpose       = "${var.purpose}"
    instantiation = "${var.instantiation}"
  }
}

resource "azurerm_dev_center_environment_type" "dev_center_env_dev" {
  name          = "Dev"
  dev_center_id = azurerm_dev_center.dev_center.id

  tags = {
    environment   = "Dev"
    purpose       = "${var.purpose}"
    instantiation = "${var.instantiation}"
  }
}

resource "azurerm_dev_center_environment_type" "dev_center_env_test" {
  name          = "Test"
  dev_center_id = azurerm_dev_center.dev_center.id

  tags = {
    environment   = "Test"
    purpose       = "${var.purpose}"
    instantiation = "${var.instantiation}"
  }
}

resource "azurerm_dev_center_environment_type" "dev_center_env_prod" {
  name          = "Prod"
  dev_center_id = azurerm_dev_center.dev_center.id

  tags = {
    environment   = "Prod"
    purpose       = "${var.purpose}"
    instantiation = "${var.instantiation}"
  }
}


resource "azurerm_dev_center_project" "project-a" {
  dev_center_id       = azurerm_dev_center.dev_center.id
  location            = azurerm_resource_group.rg.location
  name                = "dev-project-a"
  resource_group_name = azurerm_resource_group.rg.name
}


resource "azurerm_dev_center_project" "project-b" {
  dev_center_id       = azurerm_dev_center.dev_center.id
  location            = azurerm_resource_group.rg.location
  name                = "dev-project-b"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_dev_center_project" "project-c" {
  dev_center_id       = azurerm_dev_center.dev_center.id
  location            = azurerm_resource_group.rg.location
  name                = "dev-project-c"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_dev_center_project" "project-d" {
  dev_center_id       = azurerm_dev_center.dev_center.id
  location            = azurerm_resource_group.rg.location
  name                = "dev-project-d"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_dev_center_project" "project-e" {
  dev_center_id       = azurerm_dev_center.dev_center.id
  location            = azurerm_resource_group.rg.location
  name                = "dev-project-e"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_dev_center_project" "project-f" {
  dev_center_id       = azurerm_dev_center.dev_center.id
  location            = azurerm_resource_group.rg.location
  name                = "dev-project-f"
  resource_group_name = azurerm_resource_group.rg.name
}



resource "azurerm_key_vault" "kv" {
  name                     = "${var.kv_name}${random_id.rg_name.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = true
  access_policy {
    tenant_id          = data.azurerm_client_config.current.tenant_id
    object_id          = data.azurerm_client_config.current.object_id
    secret_permissions = ["Get", "Set", "List"]
  }
}
