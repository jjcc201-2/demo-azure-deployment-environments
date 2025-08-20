output "dev_center_id" {
  description = "The ID of the Dev Center"
  value       = azurerm_dev_center.dev_center.id
}

output "dev_center_name" {
  description = "The name of the Dev Center"
  value       = azurerm_dev_center.dev_center.name
}

output "identity_principal_id" {
  description = "The principal ID of the Dev Center's managed identity"
  value       = azurerm_dev_center.dev_center.identity[0].principal_id
}