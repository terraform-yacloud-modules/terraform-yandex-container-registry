data "yandex_client_config" "client" {}

resource "yandex_iam_service_account" "pusher" {
  name = "complete-registry-pusher"
}

resource "yandex_iam_service_account" "admin" {
  name = "complete-registry-admin"
}

module "cr" {
  source = "../../"

  registry  = "complete"
  folder_id = data.yandex_client_config.client.folder_id

  labels = {
    environment = "test"
    managed_by  = "terraform"
    example     = "complete"
  }

  role    = "puller"
  members = ["system:allUsers"]

  iam_bindings = {
    pusher = {
      role    = "pusher"
      members = ["serviceAccount:${yandex_iam_service_account.pusher.id}"]
    }
    admin = {
      role    = "admin"
      members = ["serviceAccount:${yandex_iam_service_account.admin.id}"]
    }
  }

  registry_ip_permission = {
    push = ["192.168.1.0/24"]
    pull = ["10.0.0.0/16", "172.16.0.0/12"]
  }

  timeouts = {
    create = "40m"
    read   = "40m"
    update = "40m"
    delete = "40m"
  }

  repos = {
    "frontend" = {
      role    = "pusher"
      members = ["serviceAccount:${yandex_iam_service_account.pusher.id}"]
      iam_bindings = {
        admin = {
          role    = "admin"
          members = ["serviceAccount:${yandex_iam_service_account.admin.id}"]
        }
        readers = {
          role    = "puller"
          members = ["system:allUsers"]
        }
      }
      lifecycle_policy = {
        name        = "frontend-cleanup-policy"
        status      = "active"
        description = "Cleanup policy for frontend images"
        rules = [
          {
            description   = "Delete untagged images after 24 hours"
            expire_period = "24h"
            untagged      = true
            tag_regexp    = ".*"
            retained_top  = 2
          },
          {
            description   = "Delete release images after 168 hours"
            expire_period = "168h"
            untagged      = false
            tag_regexp    = "^release-.*"
            retained_top  = 5
          }
        ]
      }
    },
    "worker" = {
      role    = "puller"
      members = ["system:allUsers"]
      lifecycle_policy = {
        name          = "worker-cleanup-policy"
        status        = "active"
        description   = "Cleanup policy for worker images"
        expire_period = "48h"
        untagged      = true
        tag_regexp    = ".*"
        retained_top  = 1
      }
    }
  }
}
