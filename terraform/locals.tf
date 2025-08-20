locals {

  common_tags = {
    environment = var.environment
    purpose     = var.purpose
  }

  users_data      = try(yamldecode(file("${path.module}/../users.yaml")), { users = [] })
  user_object_ids = [for user in local.users_data.users : user.object_id]
}

// Create random ID to add as prefix for all resources created
resource "random_id" "rg_name" {
  byte_length = 4
}