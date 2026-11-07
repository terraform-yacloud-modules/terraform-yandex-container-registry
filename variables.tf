variable "registry" {
  description = "Container registry name"
  type        = string

  validation {
    condition     = length(var.registry) > 0
    error_message = "Registry name cannot be empty."
  }
}

variable "labels" {
  description = "Container registry labels"
  type        = map(string)
  default     = {}
}

# see https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/container_registry_iam_binding
variable "members" {
  description = "The role that should be applied"
  type        = list(string)
  default     = ["system:allUsers"]

  validation {
    condition = alltrue([
      for member in var.members :
      can(regex("^(system:allUsers|system:allAuthenticatedUsers|userAccount:|serviceAccount:|federation:|group:|allUsers|allAuthenticatedUsers)", member))
    ])
    error_message = "Members must be in valid format: system:allUsers, system:allAuthenticatedUsers, userAccount:{user_id}, serviceAccount:{service_account_id}, federation:{federation_id}, group:{group_id}, allUsers, or allAuthenticatedUsers."
  }
}

# see https://cloud.yandex.com/en/docs/container-registry/security/
variable "role" {
  description = "The role that should be applied"
  type        = string
  default     = "puller"

  validation {
    condition     = contains(["puller", "pusher", "admin"], var.role)
    error_message = "Role must be one of `puller`, `pusher` or `admin`."
  }
}

variable "iam_bindings" {
  description = "Additional registry-level IAM bindings as a map of binding name to role and members. Applied in addition to `role` and `members`"
  type = map(object({
    role    = string
    members = list(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for binding in values(var.iam_bindings) :
      contains(["puller", "pusher", "admin"], binding.role)
    ])
    error_message = "IAM binding role must be one of `puller`, `pusher` or `admin`."
  }

  validation {
    condition = alltrue([
      for binding in values(var.iam_bindings) :
      alltrue([
        for member in binding.members :
        can(regex("^(system:allUsers|system:allAuthenticatedUsers|userAccount:|serviceAccount:|federation:|group:|allUsers|allAuthenticatedUsers)", member))
      ])
    ])
    error_message = "IAM binding members must be in valid format: system:allUsers, system:allAuthenticatedUsers, userAccount:{user_id}, serviceAccount:{service_account_id}, federation:{federation_id}, group:{group_id}, allUsers, or allAuthenticatedUsers."
  }
}

variable "repos" {
  description = "Repositories with role binding, additional iam_bindings and lifecycle_policy (single rule fields or a list of rules)"
  type = map(object({
    role    = optional(string, "puller")
    members = optional(list(string), ["system:allUsers"])
    iam_bindings = optional(map(object({
      role    = string
      members = list(string)
    })), {})
    lifecycle_policy = optional(object({
      name          = optional(string, "")
      status        = optional(string, "active")
      description   = optional(string, "")
      expire_period = optional(string, "24h")
      untagged      = optional(bool, true)
      tag_regexp    = optional(string, ".*")
      retained_top  = optional(number, 1)
      rules = optional(list(object({
        description   = optional(string, "")
        expire_period = optional(string, "24h")
        untagged      = optional(bool, true)
        tag_regexp    = optional(string, ".*")
        retained_top  = optional(number, 1)
      })), [])
    }), null)
  }))
  default = {}

  validation {
    condition = alltrue([
      for repo_name, repo_config in var.repos :
      contains(["puller", "pusher", "admin"], try(repo_config.role, "puller"))
    ])
    error_message = "Repository role must be one of `puller`, `pusher` or `admin`."
  }

  validation {
    condition = alltrue([
      for repo_name, repo_config in var.repos :
      contains(["active", "disabled"], lookup(repo_config.lifecycle_policy, "status", "active")) if lookup(repo_config, "lifecycle_policy", null) != null
    ])
    error_message = "Lifecycle policy status must be either 'active' or 'disabled'."
  }

  validation {
    condition = alltrue([
      for repo_name, repo_config in var.repos :
      can(regex("^\\d+h$", lookup(repo_config.lifecycle_policy, "expire_period", "24h"))) &&
      (tonumber(replace(lookup(repo_config.lifecycle_policy, "expire_period", "24h"), "h", "")) % 24 == 0)
      if lookup(repo_config, "lifecycle_policy", null) != null
    ])
    error_message = "Expire period must be in format 'Nh' where N is a multiple of 24 (e.g., '24h', '48h', '168h')."
  }

  validation {
    condition = alltrue([
      for repo_name, repo_config in var.repos :
      can(regex("^.*$", lookup(repo_config.lifecycle_policy, "tag_regexp", ".*")))
      if lookup(repo_config, "lifecycle_policy", null) != null
    ])
    error_message = "Tag regexp must be a valid regular expression."
  }

  validation {
    condition = alltrue([
      for repo_name, repo_config in var.repos :
      alltrue([
        for rule in try(repo_config.lifecycle_policy.rules, []) :
        can(regex("^\\d+h$", lookup(rule, "expire_period", "24h"))) &&
        (tonumber(replace(lookup(rule, "expire_period", "24h"), "h", "")) % 24 == 0)
      ])
      if lookup(repo_config, "lifecycle_policy", null) != null
    ])
    error_message = "Each lifecycle rule expire_period must be in format 'Nh' where N is a multiple of 24 (e.g., '24h', '48h', '168h')."
  }

  validation {
    condition = alltrue([
      for repo_name, repo_config in var.repos :
      alltrue([
        for binding in values(try(repo_config.iam_bindings, {})) :
        contains(["puller", "pusher", "admin"], binding.role)
      ])
    ])
    error_message = "Repository IAM binding role must be one of `puller`, `pusher` or `admin`."
  }

  validation {
    condition = alltrue([
      for repo_name, repo_config in var.repos :
      alltrue([
        for binding in values(try(repo_config.iam_bindings, {})) :
        alltrue([
          for member in binding.members :
          can(regex("^(system:allUsers|system:allAuthenticatedUsers|userAccount:|serviceAccount:|federation:|group:|allUsers|allAuthenticatedUsers)", member))
        ])
      ])
    ])
    error_message = "Repository IAM binding members must be in valid format: system:allUsers, system:allAuthenticatedUsers, userAccount:{user_id}, serviceAccount:{service_account_id}, federation:{federation_id}, group:{group_id}, allUsers, or allAuthenticatedUsers."
  }
}



variable "timeouts" {
  description = "Timeout settings for cluster operations"
  type = object({
    create = optional(string)
    read   = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}

variable "folder_id" {
  description = "The folder ID where the registry will be created. If not provided, uses the default folder from the provider configuration"
  type        = string
  default     = null
}

variable "registry_ip_permission" {
  description = "IP permission settings for the container registry"
  type = object({
    push = optional(list(string))
    pull = optional(list(string))
  })
  default = null

  validation {
    condition = var.registry_ip_permission == null ? true : (
      alltrue([
        for ip in try(var.registry_ip_permission.push, []) :
        can(cidrnetmask(ip))
        ]) && alltrue([
        for ip in try(var.registry_ip_permission.pull, []) :
        can(cidrnetmask(ip))
      ])
    )
    error_message = "IP addresses must be in valid CIDR format (e.g., '192.168.1.0/24')."
  }
}
