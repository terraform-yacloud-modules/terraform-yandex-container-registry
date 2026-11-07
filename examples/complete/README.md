## Usage

To run this example you need to execute:

```bash
export YC_FOLDER_ID='folder_id'
terraform init
terraform plan
terraform apply
```

This example demonstrates all module features:

- registry with labels, explicit folder and timeouts;
- registry-level IAM bindings for several roles (`iam_bindings`);
- registry IP permissions;
- repositories with a default role binding and additional IAM bindings (`iam_bindings`);
- lifecycle policies with a single rule and with multiple rules (`rules`).

Note that this example may create resources which can cost money. Run `terraform destroy` when you don't need these resources.
