output "environment" {
  description = "The selected infrastructure environment."
  value       = var.environment
}

output "project_name" {
  description = "The logical project name used by the infrastructure skeleton."
  value       = local.project_name
}

output "common_tags" {
  description = "Standard metadata tags that future infrastructure resources should inherit."
  value       = local.common_tags
}
