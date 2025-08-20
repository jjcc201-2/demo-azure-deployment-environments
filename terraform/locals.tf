locals {

  common_tags = {
    environment = var.environment
    purpose     = var.purpose
  }

}

// Create random ID to add as prefix for all resources created
resource "random_id" "rg_name" {
  byte_length = 4
}