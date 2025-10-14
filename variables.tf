variable "registry" {
  description = "Container registry name"
  type        = string
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

variable "repos" {
  description = "Repositories with role binding and lifecycle_policy"
  type        = map(any)
  default     = {}
}



variable "timeouts" {
  description = "Timeout settings for cluster operations"
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}
