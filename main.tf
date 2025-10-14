data "yandex_client_config" "client" {}

###########
## Registry
###########
resource "yandex_container_registry" "this" {
  name      = var.registry
  folder_id = data.yandex_client_config.client.folder_id

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
  role          = "container-registry.images.${lookup(each.value, "role", "puller")}"
  members       = lookup(each.value, "members", ["system:allUsers"])
}

resource "yandex_container_repository_lifecycle_policy" "this" {
  for_each = var.repos

  name          = lookup(each.value["lifecycle_policy"], "name", "")
  status        = lookup(each.value["lifecycle_policy"], "status", "active")
  description   = lookup(each.value["lifecycle_policy"], "description", "")
  repository_id = yandex_container_repository.this[each.key].id

  rule {
    description = lookup(each.value["lifecycle_policy"], "description", "")
    #  The period of time that must pass after creating a image for it to suit the automatic deletion criteria. It must be a multiple of 24 hours
    expire_period = lookup(each.value["lifecycle_policy"], "expire_period", "24h")
    # If untagged enabled, rules apply to untagged Docker images.
    untagged = lookup(each.value["lifecycle_policy"], "untagged", true)
    # Tag to specify a filter as a regular expression. For example .* - all images with tags
    tag_regexp = lookup(each.value["lifecycle_policy"], "tag_regexp", ".*")
    # The number of images to be retained even if the expire_period already expired
    retained_top = lookup(each.value["lifecycle_policy"], "retained_top", 1)
  }

}
