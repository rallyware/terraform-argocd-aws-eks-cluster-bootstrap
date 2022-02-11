## Usage

```hcl
module "apps" {
  source              = "git::https://github.com/rallyware/terraform-argocd-aws-eks-cluster-bootstrap.git?ref=master"
  argocd_iam_role_arn = "argocd-role-arn"
  eks_cluster_id      = "staging-cluster"

  argocd_additional_projects = [
    {
      name = "test"
    }
  ]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_argocd"></a> [argocd](#requirement\_argocd) | >= 1.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | < 4.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.0 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | >= 0.14.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_apps"></a> [apps](#module\_apps) | ../../ | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS --> 

## License
The Apache-2.0 license