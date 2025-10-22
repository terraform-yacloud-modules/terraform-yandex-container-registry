output "registry_id" {
  description = "Registry ID"
  value       = yandex_container_registry.this.id
}

output "registry_name" {
  description = "Registry name"
  value       = yandex_container_registry.this.name
}

output "registry_folder_id" {
  description = "Registry folder ID"
  value       = yandex_container_registry.this.folder_id
}

output "registry_labels" {
  description = "Registry labels"
  value       = yandex_container_registry.this.labels
}

output "registry_created_at" {
  description = "Registry creation timestamp"
  value       = yandex_container_registry.this.created_at
}

output "registry_status" {
  description = "Registry status"
  value       = yandex_container_registry.this.status
}

output "repository_ids" {
  description = "Map of repository IDs"
  value       = { for k, v in yandex_container_repository.this : k => v.id }
}

output "repository_names" {
  description = "Map of repository names"
  value       = { for k, v in yandex_container_repository.this : k => v.name }
}

output "lifecycle_policy_ids" {
  description = "Map of lifecycle policy IDs"
  value       = { for k, v in yandex_container_repository_lifecycle_policy.this : k => v.id }
}
