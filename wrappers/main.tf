module "wrapper" {
  source   = "../"
  for_each = var.items

  registry               = try(each.value.registry, var.defaults.registry, each.key)
  folder_id              = try(each.value.folder_id, var.defaults.folder_id, null)
  labels                 = try(each.value.labels, var.defaults.labels, {})
  role                   = try(each.value.role, var.defaults.role, "puller")
  members                = try(each.value.members, var.defaults.members, ["system:allUsers"])
  repos                  = try(each.value.repos, var.defaults.repos, {})
  timeouts               = try(each.value.timeouts, var.defaults.timeouts, null)
  registry_ip_permission = try(each.value.registry_ip_permission, var.defaults.registry_ip_permission, null)
}
