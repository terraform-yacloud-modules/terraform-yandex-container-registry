# Yandex Cloud Container Registry Terraform module

Terraform module which creates Yandex Cloud Container Registry resources with repositories, IAM bindings, lifecycle policies, and IP permissions.

## Examples

Examples codified under
the [`examples`](https://github.com/terraform-yacloud-modules/terraform-yandex-module-template/tree/main/examples) are intended
to give users references for how to use the module(s) as well as testing/validating changes to the source code of the
module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow
maintainers to test your changes and to keep the examples up to date for users. Thank you!

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | >= 0.47.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | >= 0.47.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_container_registry.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/container_registry) | resource |
| [yandex_container_registry_iam_binding.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/container_registry_iam_binding) | resource |
| [yandex_container_registry_ip_permission.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/container_registry_ip_permission) | resource |
| [yandex_container_repository.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/container_repository) | resource |
| [yandex_container_repository_iam_binding.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/container_repository_iam_binding) | resource |
| [yandex_container_repository_lifecycle_policy.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/container_repository_lifecycle_policy) | resource |
| [yandex_client_config.client](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | The folder ID where the registry will be created. If not provided, uses the default folder from the provider configuration | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Container registry labels | `map(string)` | `{}` | no |
| <a name="input_members"></a> [members](#input\_members) | The role that should be applied | `list(string)` | <pre>[<br/>  "system:allUsers"<br/>]</pre> | no |
| <a name="input_registry"></a> [registry](#input\_registry) | Container registry name | `string` | n/a | yes |
| <a name="input_registry_ip_permission"></a> [registry\_ip\_permission](#input\_registry\_ip\_permission) | IP permission settings for the container registry | <pre>object({<br/>    push = optional(list(string))<br/>    pull = optional(list(string))<br/>  })</pre> | `null` | no |
| <a name="input_repos"></a> [repos](#input\_repos) | Repositories with role binding and lifecycle\_policy | `map(any)` | `{}` | no |
| <a name="input_role"></a> [role](#input\_role) | The role that should be applied | `string` | `"puller"` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Timeout settings for cluster operations | <pre>object({<br/>    create = optional(string)<br/>    update = optional(string)<br/>    delete = optional(string)<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lifecycle_policy_ids"></a> [lifecycle\_policy\_ids](#output\_lifecycle\_policy\_ids) | Map of lifecycle policy IDs |
| <a name="output_registry_created_at"></a> [registry\_created\_at](#output\_registry\_created\_at) | Registry creation timestamp |
| <a name="output_registry_folder_id"></a> [registry\_folder\_id](#output\_registry\_folder\_id) | Registry folder ID |
| <a name="output_registry_id"></a> [registry\_id](#output\_registry\_id) | Registry ID |
| <a name="output_registry_labels"></a> [registry\_labels](#output\_registry\_labels) | Registry labels |
| <a name="output_registry_name"></a> [registry\_name](#output\_registry\_name) | Registry name |
| <a name="output_registry_status"></a> [registry\_status](#output\_registry\_status) | Registry status |
| <a name="output_repository_ids"></a> [repository\_ids](#output\_repository\_ids) | Map of repository IDs |
| <a name="output_repository_names"></a> [repository\_names](#output\_repository\_names) | Map of repository names |
<!-- END_TF_DOCS -->

## License

Apache-2.0 Licensed.
See [LICENSE](https://github.com/terraform-yacloud-modules/terraform-yandex-module-template/blob/main/LICENSE).
