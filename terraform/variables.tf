variable "location" {
  description = "The Azure region to deploy all resources."
  type        = string
  default     = "uksouth"
}

variable "environment" {
  description = "The type of environment. Used for tagging"
  type        = string
  default     = "dev"
}

variable "purpose" {
  description = "The purpose of the workload. Used for tagging"
  type        = string
  default     = "demo"
}

variable "instantiation" {
  description = "How the workload was deployed. Used for tagging"
  type        = string
  default     = "terraform"
}

variable "rg_name" {
  description = "The name of the resource group."
  type        = string
  default     = "rg-deployment-env-demo"
}

variable "kv_name" {
  description = "Key Vault name."
  type        = string
  default     = "kv"
}

variable "github_pat" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "github_uri" {
  description = "GitHub URI"
  type        = string
  sensitive   = true
}