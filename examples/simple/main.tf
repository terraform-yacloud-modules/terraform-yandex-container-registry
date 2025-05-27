resource "yandex_iam_service_account" "registry" {
  name = "registry"
}

module "cr" {
  source = "../../"

  registry = "test"

  role    = "puller"
  members = ["system:allUsers"]

  repos = {
    "frontend" = {
      role = "pusher"
      members = [
        "serviceAccount:${yandex_iam_service_account.registry.id}"
      ]
      lifecycle_policy = {
        name         = "frontend-cleanup-policy"
        status       = "active"
        description  = "Cleanup policy for frontend images"
        expire_period = "168h"  # 7 дней
        untagged     = true
        tag_regexp   = ".*"
        retained_top = 5
      }
    },
    "worker" = {
      role = "puller"
      members = [
        "system:allUsers"
      ]
      lifecycle_policy = {
        name         = "worker-cleanup-policy"
        status       = "active"
        description  = "Cleanup policy for worker images"
        expire_period = "24h"   # 1 день
        untagged     = true
        tag_regexp   = "latest"
        retained_top = 1
      }
    }
  }

}
