
# Key Vault
resource "azurerm_key_vault" "kv" {
  name                     = var.name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  tenant_id                = var.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = true
  tags                     = var.tags
}


# Access policy for Dev Center managed identity to read GitHub PAT
resource "azurerm_key_vault_access_policy" "kv-ap-devcenter" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = var.tenant_id
  object_id    = var.dev_center_principal_id

  secret_permissions = ["Get", "List"]
}

# Access policy for current user to manage GitHub PAT
resource "azurerm_key_vault_access_policy" "kv-ap-user" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = var.tenant_id
  object_id    = var.current_user_object_id

  secret_permissions = ["Get", "Set", "List", "Delete"]
}


resource "azurerm_key_vault_secret" "github_pat" {
  name         = "PAT-gh-ade"
  value        = var.github_pat
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_key_vault_access_policy.kv-ap-user]
}