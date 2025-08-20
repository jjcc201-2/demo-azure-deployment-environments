output "id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.kv.id
}

output "name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.kv.name
}

output "github_pat_secret_id" {
  description = "The ID of the GitHub PAT secret"
  value       = azurerm_key_vault_secret.github_pat.id
}