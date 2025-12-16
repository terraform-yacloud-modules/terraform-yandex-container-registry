# Wrapper Module for Yandex Cloud Container Registry

This wrapper module introduces a pattern that enables bulk creation of multiple Container Registries with shared default configurations. It uses Terraform's `for_each` meta-argument to instantiate the main Container Registry module multiple times.

## Usage with Terragrunt

```hcl
terraform {
  source = "git::https://github.com/terraform-yacloud-modules/terraform-yandex-container-registry.git//wrappers?ref=main"
}

inputs = {
  defaults = {
    folder_id = "b1g1234567890abcdef"
    role      = "puller"
    members   = ["system:allUsers"]
    labels = {
      environment = "production"
    }
  }

  items = {
    frontend = {
      registry = "frontend-registry"
      role     = "pusher"
      members  = ["serviceAccount:abc123"]
      repos = {
        "app" = {
          role    = "pusher"
          members = ["serviceAccount:abc123"]
          lifecycle_policy = {
            name          = "app-cleanup"
            status        = "active"
            expire_period = "168h"
            retained_top  = 5
          }
        }
      }
    }

    backend = {
      registry = "backend-registry"
      registry_ip_permission = {
        push = ["10.0.0.0/8"]
        pull = ["0.0.0.0/0"]
      }
      repos = {
        "api" = {
          role    = "puller"
          members = ["system:allUsers"]
          lifecycle_policy = {
            name          = "api-cleanup"
            status        = "active"
            expire_period = "24h"
            retained_top  = 3
          }
        }
      }
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| defaults | Map of default values which will be used for each item | `any` | `{}` | no |
| items | Maps of items to create a wrapper from. Each item must include 'registry' | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| wrapper | Map of outputs of a wrapper |

## Item Configuration

Each item in the `items` map can include:

| Name | Description | Default |
|------|-------------|---------|
| registry | Container registry name | key name |
| folder_id | The folder ID where the registry will be created | `null` |
| labels | Container registry labels | `{}` |
| role | Registry-level role (puller/pusher/admin) | `"puller"` |
| members | IAM members for registry-level binding | `["system:allUsers"]` |
| repos | Map of repositories with role bindings and lifecycle policies | `{}` |
| timeouts | Timeout settings for operations | `null` |
| registry_ip_permission | IP permission settings (push/pull CIDRs) | `null` |
