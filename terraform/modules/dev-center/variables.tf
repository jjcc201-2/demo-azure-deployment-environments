variable "name" {
  description = "Name for the Dev Center"
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

variable "tags" {
    description = "Tags to apply to resources"
    type        = map(string)
    default     = {}
}

variable "github_uri" {
  description = "GitHub URI"
  type        = string
  sensitive   = true
}

variable "github_pat_secret_id" {
  description = "Key Vault secret ID for GitHub PAT"
  type        = string
}