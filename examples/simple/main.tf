locals {
  policy = {
    expire_period = "48h"
  }
  sa_id = "xxx"
}

module "cr" {
  source = "../../"

  registry = "test"

  role    = "puller"
  members = ["system:allUsers"]

  repos = {
    test1 = {
      role = "pusher"
      members = [
        "serviceAccount:${local.sa_id}"
      ]
      lifecycle_policy = local.policy
    },
    test2 = {
      role = "pusher"
      members = [
        "serviceAccount:${local.sa_id}"
      ]
      lifecycle_policy = local.policy
    }
  }

}
