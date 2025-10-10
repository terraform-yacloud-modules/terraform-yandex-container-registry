# Yandex Cloud <RESOURCE> Terraform module

Terraform module which creates Yandex Cloud <RESOURCE> resources.

## Examples

Examples codified under
the [`examples`](https://github.com/terraform-yacloud-modules/terraform-yandex-module-template/tree/main/examples) are intended
to give users references for how to use the module(s) as well as testing/validating changes to the source code of the
module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow
maintainers to test your changes and to keep the examples up to date for users. Thank you!

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
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
| [yandex_container_repository.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/container_repository) | resource |
| [yandex_container_repository_iam_binding.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/container_repository_iam_binding) | resource |
| [yandex_container_repository_lifecycle_policy.this](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/container_repository_lifecycle_policy) | resource |
| [yandex_client_config.client](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_labels"></a> [labels](#input\_labels) | Container registry labels | `map(string)` | `{}` | no |
| <a name="input_members"></a> [members](#input\_members) | The role that should be applied | `list(string)` | <pre>[<br/>  "system:allUsers"<br/>]</pre> | no |
| <a name="input_registry"></a> [registry](#input\_registry) | Container registry name | `string` | n/a | yes |
| <a name="input_repos"></a> [repos](#input\_repos) | Repositories with role binding and lifecycle\_policy | `map(any)` | `{}` | no |
| <a name="input_role"></a> [role](#input\_role) | The role that should be applied | `string` | `"puller"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_registry_id"></a> [registry\_id](#output\_registry\_id) | Registry ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed.
See [LICENSE](https://github.com/terraform-yacloud-modules/terraform-yandex-module-template/blob/main/LICENSE).
