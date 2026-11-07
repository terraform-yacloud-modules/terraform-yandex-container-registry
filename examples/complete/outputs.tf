output "registry_id" {
  description = "Registry ID"
  value       = module.cr.registry_id
}

output "repository_ids" {
  description = "Map of repository IDs"
  value       = module.cr.repository_ids
}

output "lifecycle_policy_ids" {
  description = "Map of lifecycle policy IDs"
  value       = module.cr.lifecycle_policy_ids
}
