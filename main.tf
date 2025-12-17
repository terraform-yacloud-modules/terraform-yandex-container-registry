data "yandex_client_config" "client" {}

###########
## Registry
###########
resource "yandex_container_registry" "this" {
  name      = var.registry
  folder_id = coalesce(var.folder_id, data.yandex_client_config.client.folder_id)

  labels = var.labels == null ? { project = var.registry } : var.labels

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]
    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }
}

resource "yandex_container_registry_iam_binding" "this" {
  registry_id = yandex_container_registry.this.id
  role        = "container-registry.images.${var.role}"
  members     = var.members
}

resource "yandex_container_registry_ip_permission" "this" {
  count = var.registry_ip_permission != null ? 1 : 0

  registry_id = yandex_container_registry.this.id

  push = try(var.registry_ip_permission.push, [])
  pull = try(var.registry_ip_permission.pull, [])
}

#############
## Repository
#############
resource "yandex_container_repository" "this" {
  for_each = var.repos
  name     = "${yandex_container_registry.this.id}/${each.key}"

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]
    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }
}

resource "yandex_container_repository_iam_binding" "this" {
  for_each = var.repos

  repository_id = yandex_container_repository.this[each.key].id
  role          = "container-registry.images.${try(each.value.role, "puller")}"
  members       = try(each.value.members, ["system:allUsers"])
}

resource "yandex_container_repository_lifecycle_policy" "this" {
  # Only create lifecycle policies for repos that have lifecycle_policy defined
  for_each = { for k, v in var.repos : k => v if try(v.lifecycle_policy, null) != null }

  name          = try(each.value.lifecycle_policy.name, "")
  status        = try(each.value.lifecycle_policy.status, "active")
  description   = try(each.value.lifecycle_policy.description, "")
  repository_id = yandex_container_repository.this[each.key].id

  rule {
    description   = try(each.value.lifecycle_policy.description, "")
    expire_period = try(each.value.lifecycle_policy.expire_period, "24h")
    untagged      = try(each.value.lifecycle_policy.untagged, true)
    tag_regexp    = try(each.value.lifecycle_policy.tag_regexp, ".*")
    retained_top  = try(each.value.lifecycle_policy.retained_top, 1)
  }
}
