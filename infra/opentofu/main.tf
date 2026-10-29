locals {
  project_name = "game-security-lab"

  common_tags = {
    project     = local.project_name
    environment = var.environment
    managed_by  = "opentofu"
    domain      = "gaming-devsecops"
  }
}
