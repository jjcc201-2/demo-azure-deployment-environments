variable "name" {
  description = "Name for the Key Vault"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "github_pat" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "dev_center_principal_id" {
  description = "Principal ID of the Dev Center's managed identity"
  type        = string
}

variable "current_user_object_id" {
  description = "Object ID of the current user"
  type        = string
}