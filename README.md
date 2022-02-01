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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.0 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | >= 0.14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_argocd"></a> [argocd](#provider\_argocd) | >= 1.2 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 3.0 |
| <a name="provider_utils"></a> [utils](#provider\_utils) | >= 0.14.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster_autoscaler_eks_iam_role"></a> [cluster\_autoscaler\_eks\_iam\_role](#module\_cluster\_autoscaler\_eks\_iam\_role) | rallyware/eks-iam-role/aws | 0.1.1 |
| <a name="module_cluster_autoscaler_label"></a> [cluster\_autoscaler\_label](#module\_cluster\_autoscaler\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_crd_apps_label"></a> [crd\_apps\_label](#module\_crd\_apps\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_ebs_csi_eks_iam_role"></a> [ebs\_csi\_eks\_iam\_role](#module\_ebs\_csi\_eks\_iam\_role) | rallyware/eks-iam-role/aws | 0.1.1 |
| <a name="module_ebs_csi_kms_key"></a> [ebs\_csi\_kms\_key](#module\_ebs\_csi\_kms\_key) | cloudposse/kms-key/aws | 0.12.1 |
| <a name="module_ebs_csi_label"></a> [ebs\_csi\_label](#module\_ebs\_csi\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_helm_apps_label"></a> [helm\_apps\_label](#module\_helm\_apps\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_karpenter_eks_iam_role"></a> [karpenter\_eks\_iam\_role](#module\_karpenter\_eks\_iam\_role) | rallyware/eks-iam-role/aws | 0.1.1 |
| <a name="module_karpenter_label"></a> [karpenter\_label](#module\_karpenter\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_piggy_webhooks_eks_iam_role"></a> [piggy\_webhooks\_eks\_iam\_role](#module\_piggy\_webhooks\_eks\_iam\_role) | rallyware/eks-iam-role/aws | 0.1.1 |
| <a name="module_piggy_webhooks_label"></a> [piggy\_webhooks\_label](#module\_piggy\_webhooks\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |
| <a name="module_velero_eks_iam_role"></a> [velero\_eks\_iam\_role](#module\_velero\_eks\_iam\_role) | rallyware/eks-iam-role/aws | 0.1.1 |
| <a name="module_velero_kms_key"></a> [velero\_kms\_key](#module\_velero\_kms\_key) | cloudposse/kms-key/aws | 0.12.1 |
| <a name="module_velero_label"></a> [velero\_label](#module\_velero\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_velero_s3_bucket"></a> [velero\_s3\_bucket](#module\_velero\_s3\_bucket) | cloudposse/s3-bucket/aws | 0.44.1 |

## Resources

| Name | Type |
|------|------|
| [argocd_application.crd_apps](https://registry.terraform.io/providers/oboukili/argocd/latest/docs/resources/application) | resource |
| [argocd_application.helm_apps](https://registry.terraform.io/providers/oboukili/argocd/latest/docs/resources/application) | resource |
| [argocd_cluster.default](https://registry.terraform.io/providers/oboukili/argocd/latest/docs/resources/cluster) | resource |
| [argocd_project.additional](https://registry.terraform.io/providers/oboukili/argocd/latest/docs/resources/project) | resource |
| [argocd_project.default](https://registry.terraform.io/providers/oboukili/argocd/latest/docs/resources/project) | resource |
| [tls_private_key.linkerd](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.linkerd](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [aws_caller_identity.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_iam_policy_document.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ebs_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.karpenter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.piggy_webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.velero](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [utils_deep_merge_yaml.argocd_helm_apps](https://registry.terraform.io/providers/cloudposse/utils/latest/docs/data-sources/deep_merge_yaml) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_iam_role_arn"></a> [argocd\_iam\_role\_arn](#input\_argocd\_iam\_role\_arn) | IAM role ARN for ArgoCD to authenticate in EKS cluster. | `string` | n/a | yes |
| <a name="input_eks_cluster_id"></a> [eks\_cluster\_id](#input\_eks\_cluster\_id) | EKS cluster ID. | `string` | n/a | yes |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_app_of_apps_helm_chart"></a> [app\_of\_apps\_helm\_chart](#input\_app\_of\_apps\_helm\_chart) | n/a | <pre>object(<br>    {<br>      chart      = string<br>      repository = string<br>      version    = string<br>    }<br>  )</pre> | <pre>{<br>  "chart": "argocd-app-of-apps",<br>  "repository": "https://sweetops.github.io/helm-charts",<br>  "version": "0.1.5"<br>}</pre> | no |
| <a name="input_argocd_additional_projects"></a> [argocd\_additional\_projects](#input\_argocd\_additional\_projects) | A list of additional ArgoCD projects to create. | <pre>list(object(<br>    {<br>      name        = string<br>      description = optional(string)<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_argocd_app_annotations"></a> [argocd\_app\_annotations](#input\_argocd\_app\_annotations) | An unstructured key value map stored with the config map that may be used to store arbitrary metadata. | `map(string)` | `{}` | no |
| <a name="input_argocd_cluster_name"></a> [argocd\_cluster\_name](#input\_argocd\_cluster\_name) | The name of kubernetes cluster where ArgoCD is installed. Check https://YOUR_ARGOCD_HOSTNAME/settings/clusters to verify it. | `string` | `"in-cluster"` | no |
| <a name="input_argocd_crd_apps"></a> [argocd\_crd\_apps](#input\_argocd\_crd\_apps) | n/a | <pre>list(object(<br>    {<br>      name       = string<br>      repository = string<br>      path       = string<br>      version    = string<br><br>    }<br>  ))</pre> | <pre>[<br>  {<br>    "name": "prometheus-operator-crds",<br>    "path": "example/prometheus-operator-crd/",<br>    "repository": "https://github.com/prometheus-operator/prometheus-operator.git",<br>    "version": "v0.52.1"<br>  }<br>]</pre> | no |
| <a name="input_argocd_helm_app_default_params"></a> [argocd\_helm\_app\_default\_params](#input\_argocd\_helm\_app\_default\_params) | n/a | <pre>object(<br>    {<br>      max_history     = number<br>      override_values = string<br>      sync_wave       = number<br>    }<br>  )</pre> | <pre>{<br>  "max_history": 10,<br>  "override_values": "",<br>  "sync_wave": 50<br>}</pre> | no |
| <a name="input_argocd_helm_apps"></a> [argocd\_helm\_apps](#input\_argocd\_helm\_apps) | n/a | <pre>list(object(<br>    {<br>      name            = string<br>      namespace       = string<br>      repository      = string<br>      chart           = string<br>      version         = string<br>      override_values = optional(string)<br>      max_history     = optional(number)<br>      sync_wave       = optional(number)<br>    }<br>  ))</pre> | <pre>[<br>  {<br>    "chart": "aws-vpc-cni",<br>    "name": "aws-vpc-cni",<br>    "namespace": "kube-system",<br>    "repository": "https://aws.github.io/eks-charts",<br>    "sync_wave": -11,<br>    "version": "1.1.12"<br>  },<br>  {<br>    "chart": "tigera-operator",<br>    "name": "calico",<br>    "namespace": "calico-system",<br>    "repository": "https://docs.projectcalico.org/charts",<br>    "sync_wave": -10,<br>    "version": "v3.20.2"<br>  },<br>  {<br>    "chart": "argo-rollouts",<br>    "name": "argo-rollouts",<br>    "namespace": "argo",<br>    "repository": "https://argoproj.github.io/argo-helm",<br>    "version": "2.0.1"<br>  },<br>  {<br>    "chart": "node-local-dns",<br>    "name": "node-local-dns",<br>    "namespace": "kube-system",<br>    "repository": "https://sweetops.github.io/helm-charts",<br>    "sync_wave": -9,<br>    "version": "0.2.0"<br>  },<br>  {<br>    "chart": "cert-manager",<br>    "name": "cert-manager",<br>    "namespace": "cert-manager",<br>    "repository": "https://charts.jetstack.io",<br>    "sync_wave": -7,<br>    "version": "1.5.0"<br>  },<br>  {<br>    "chart": "cert-manager-issuers",<br>    "name": "cert-manager-issuers",<br>    "namespace": "cert-manager",<br>    "repository": "https://charts.adfinis.com",<br>    "sync_wave": -6,<br>    "version": "0.2.2"<br>  },<br>  {<br>    "chart": "cluster-autoscaler",<br>    "name": "cluster-autoscaler",<br>    "namespace": "kube-system",<br>    "repository": "https://kubernetes.github.io/autoscaler",<br>    "sync_wave": -8,<br>    "version": "9.10.5"<br>  },<br>  {<br>    "chart": "aws-ebs-csi-driver",<br>    "name": "ebs-csi",<br>    "namespace": "csi-drivers",<br>    "repository": "https://kubernetes-sigs.github.io/aws-ebs-csi-driver",<br>    "sync_wave": -5,<br>    "version": "2.1.0"<br>  },<br>  {<br>    "chart": "piggy-webhooks",<br>    "name": "piggy-webhooks",<br>    "namespace": "infra",<br>    "repository": "https://piggysec.com",<br>    "sync_wave": -4,<br>    "version": "0.2.9"<br>  },<br>  {<br>    "chart": "aws-node-termination-handler",<br>    "name": "aws-node-termination-handler",<br>    "namespace": "node-termination-handler",<br>    "repository": "https://aws.github.io/eks-charts",<br>    "version": "0.15.2"<br>  },<br>  {<br>    "chart": "node-problem-detector",<br>    "name": "node-problem-detector",<br>    "namespace": "node-problem-detector",<br>    "repository": "https://charts.deliveryhero.io",<br>    "version": "2.0.5"<br>  },<br>  {<br>    "chart": "ingress-nginx",<br>    "name": "ingress-nginx",<br>    "namespace": "infra",<br>    "repository": "https://kubernetes.github.io/ingress-nginx",<br>    "version": "4.0.1"<br>  },<br>  {<br>    "chart": "velero",<br>    "name": "velero",<br>    "namespace": "velero",<br>    "repository": "https://vmware-tanzu.github.io/helm-charts",<br>    "version": "2.27.0"<br>  },<br>  {<br>    "chart": "descheduler",<br>    "name": "descheduler",<br>    "namespace": "kube-system",<br>    "repository": "https://kubernetes-sigs.github.io/descheduler",<br>    "version": "0.21.0"<br>  },<br>  {<br>    "chart": "keda",<br>    "name": "keda",<br>    "namespace": "infra",<br>    "repository": "https://kedacore.github.io/charts",<br>    "version": "2.4.0"<br>  },<br>  {<br>    "chart": "falco",<br>    "name": "falco",<br>    "namespace": "falco",<br>    "repository": "https://falcosecurity.github.io/charts",<br>    "version": "1.15.7"<br>  },<br>  {<br>    "chart": "falcosidekick",<br>    "name": "falcosidekick",<br>    "namespace": "falco",<br>    "repository": "https://falcosecurity.github.io/charts",<br>    "version": "0.3.17"<br>  },<br>  {<br>    "chart": "gatekeeper",<br>    "name": "gatekeeper",<br>    "namespace": "infra",<br>    "repository": "https://open-policy-agent.github.io/gatekeeper/charts",<br>    "version": "3.6.0"<br>  },<br>  {<br>    "chart": "victoria-metrics-k8s-stack",<br>    "name": "victoria-metrics",<br>    "namespace": "monitoring",<br>    "repository": "https://victoriametrics.github.io/helm-charts",<br>    "sync_wave": -3,<br>    "version": "0.5.3"<br>  },<br>  {<br>    "chart": "linkerd2",<br>    "name": "linkerd",<br>    "namespace": "linkerd",<br>    "repository": "https://sweetops.github.io/helm-charts",<br>    "version": "0.2.0"<br>  },<br>  {<br>    "chart": "linkerd-smi",<br>    "name": "linkerd-smi",<br>    "namespace": "linkerd-smi",<br>    "repository": "https://linkerd.github.io/linkerd-smi",<br>    "version": "0.1.0"<br>  },<br>  {<br>    "chart": "linkerd-viz",<br>    "name": "linkerd-viz",<br>    "namespace": "linkerd-viz",<br>    "repository": "https://sweetops.github.io/helm-charts",<br>    "version": "0.2.0"<br>  },<br>  {<br>    "chart": "linkerd-jaeger",<br>    "name": "linkerd-jaeger",<br>    "namespace": "linkerd-jaeger",<br>    "repository": "https://sweetops.github.io/helm-charts",<br>    "version": "0.2.0"<br>  },<br>  {<br>    "chart": "prometheus-blackbox-exporter",<br>    "name": "prometheus-blackbox-exporter",<br>    "namespace": "monitoring",<br>    "repository": "https://prometheus-community.github.io/helm-charts",<br>    "version": "5.0.3"<br>  },<br>  {<br>    "chart": "karpenter",<br>    "name": "karpenter",<br>    "namespace": "karpenter",<br>    "repository": "https://charts.karpenter.sh",<br>    "version": "0.5.1"<br>  }<br>]</pre> | no |
| <a name="input_argocd_namespace"></a> [argocd\_namespace](#input\_argocd\_namespace) | The Kubernetes namespace where ArgoCD installed to. | `string` | `"argo"` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_sts_regional_endpoints_enabled"></a> [sts\_regional\_endpoints\_enabled](#input\_sts\_regional\_endpoints\_enabled) | Whether to use STS regional endpoints for service accounts | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ebs_csi_kms_key_arn"></a> [ebs\_csi\_kms\_key\_arn](#output\_ebs\_csi\_kms\_key\_arn) | EBS CSI KMS key ARN |
| <a name="output_ebs_csi_kms_key_id"></a> [ebs\_csi\_kms\_key\_id](#output\_ebs\_csi\_kms\_key\_id) | EBS CSI KMS key ID |
| <a name="output_piggy_webhooks_role_arn"></a> [piggy\_webhooks\_role\_arn](#output\_piggy\_webhooks\_role\_arn) | Piggy-Webhook role ARN |
| <a name="output_velero_kms_key_arn"></a> [velero\_kms\_key\_arn](#output\_velero\_kms\_key\_arn) | Velero KMS key ARN |
| <a name="output_velero_kms_key_id"></a> [velero\_kms\_key\_id](#output\_velero\_kms\_key\_id) | Velero KMS key ID |
| <a name="output_velero_s3_bucket_arn"></a> [velero\_s3\_bucket\_arn](#output\_velero\_s3\_bucket\_arn) | Velero S3 bucket ARN |
| <a name="output_velero_s3_bucket_id"></a> [velero\_s3\_bucket\_id](#output\_velero\_s3\_bucket\_id) | Velero S3 bucket name |
<!-- END_TF_DOCS --> 

## License
The Apache-2.0 license