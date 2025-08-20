variable "name" {
  description = "Name for the Dev Center project"
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

variable "dev_center_id" {
  description = "ID of the Dev Center"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "environment_types" {
  description = "List of environment types to enable"
  type        = list(string)
  default     = ["Dev", "Test"]
}

variable "developers_group_object_id" {
  description = "Object ID of the developers group"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID for deployment target"
  type        = string
}