# terraform-argocd-aws-eks-cluster-bootstrap

A terraform module to bootstrap apps on AWS EKS using ArgoCD.

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_argocd"></a> [argocd](#requirement\_argocd) | >= 7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.7 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.0 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | >= 0.14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_argocd"></a> [argocd](#provider\_argocd) | >= 7 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.2.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 3.0 |
| <a name="provider_utils"></a> [utils](#provider\_utils) | >= 0.14.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_apps_label"></a> [apps\_label](#module\_apps\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_argo_ecr_auth_eks_iam_role"></a> [argo\_ecr\_auth\_eks\_iam\_role](#module\_argo\_ecr\_auth\_eks\_iam\_role) | rallyware/eks-iam-role/aws | 0.3.0 |
| <a name="module_argo_ecr_auth_label"></a> [argo\_ecr\_auth\_label](#module\_argo\_ecr\_auth\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_aws_lb_controller_eks_iam_role"></a> [aws\_lb\_controller\_eks\_iam\_role](#module\_aws\_lb\_controller\_eks\_iam\_role) | rallyware/eks-iam-role/aws | 0.3.0 |
| <a name="module_aws_lb_controller_label"></a> [aws\_lb\_controller\_label](#module\_aws\_lb\_controller\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_chartmuseum_eks_iam_role"></a> [chartmuseum\_eks\_iam\_role](#module\_chartmuseum\_eks\_iam\_role) | rallyware/eks-iam-role/aws | 0.3.0 |
| <a name="module_chartmuseum_label"></a> [chartmuseum\_label](#module\_chartmuseum\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_chartmuseum_s3_bucket"></a> [chartmuseum\_s3\_bucket](#module\_chartmuseum\_s3\_bucket) | cloudposse/s3-bucket/aws | 4.2.0 |
| <a name="module_cluster_autoscaler_eks_iam_role"></a> [cluster\_autoscaler\_eks\_iam\_role](#module\_cluster\_autoscaler\_eks\_iam\_role) | rallyware/eks-iam-role/aws | 0.3.0 |
| <a name="module_cluster_autoscaler_label"></a> [cluster\_autoscaler\_label](#module\_cluster\_autoscaler\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_ebs_csi_eks_iam_role"></a> [ebs\_csi\_eks\_iam\_role](#module\_ebs\_csi\_eks\_iam\_role) | rallyware/eks-iam-role/aws | 0.3.0 |
| <a name="module_ebs_csi_kms_key"></a> [ebs\_csi\_kms\_key](#module\_ebs\_csi\_kms\_key) | cloudposse/kms-key/aws | 0.12.2 |
| <a name="module_ebs_csi_label"></a> [ebs\_csi\_label](#module\_ebs\_csi\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_efs_csi_eks_iam_role"></a> [efs\_csi\_eks\_iam\_role](#module\_efs\_csi\_eks\_iam\_role) | rallyware/eks-iam-role/aws | 0.3.0 |
| <a name="module_efs_csi_label"></a> [efs\_csi\_label](#module\_efs\_csi\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_external_secrets_eks_iam_role"></a> [external\_secrets\_eks\_iam\_role](#module\_external\_secrets\_eks\_iam\_role) | rallyware/eks-iam-role/aws | 0.3.0 |
| <a name="module_external_secrets_injector_role"></a> [external\_secrets\_injector\_role](#module\_external\_secrets\_injector\_role) | cloudposse/iam-role/aws | 0.19.0 |
| <a name="module_external_secrets_label"></a> [external\_secrets\_label](#module\_external\_secrets\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_karpenter_eks_iam_role"></a> [karpenter\_eks\_iam\_role](#module\_karpenter\_eks\_iam\_role) | rallyware/eks-iam-role/aws | 0.3.0 |
| <a name="module_karpenter_event_label"></a> [karpenter\_event\_label](#module\_karpenter\_event\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_karpenter_instance_profile"></a> [karpenter\_instance\_profile](#module\_karpenter\_instance\_profile) | cloudposse/iam-role/aws | 0.19.0 |
| <a name="module_karpenter_label"></a> [karpenter\_label](#module\_karpenter\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_karpenter_sqs"></a> [karpenter\_sqs](#module\_karpenter\_sqs) | rallyware/sqs-queue/aws | 0.2.1 |
| <a name="module_keda_eks_iam_role"></a> [keda\_eks\_iam\_role](#module\_keda\_eks\_iam\_role) | rallyware/eks-iam-role/aws | 0.3.0 |
| <a name="module_keda_label"></a> [keda\_label](#module\_keda\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_loki_eks_iam_role"></a> [loki\_eks\_iam\_role](#module\_loki\_eks\_iam\_role) | rallyware/eks-iam-role/aws | 0.3.0 |
| <a name="module_loki_label"></a> [loki\_label](#module\_loki\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_loki_s3_bucket"></a> [loki\_s3\_bucket](#module\_loki\_s3\_bucket) | cloudposse/s3-bucket/aws | 4.2.0 |
| <a name="module_piggy_webhooks_eks_iam_role"></a> [piggy\_webhooks\_eks\_iam\_role](#module\_piggy\_webhooks\_eks\_iam\_role) | rallyware/eks-iam-role/aws | 0.3.0 |
| <a name="module_piggy_webhooks_label"></a> [piggy\_webhooks\_label](#module\_piggy\_webhooks\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_prometheus_yace_exporter_eks_iam_role"></a> [prometheus\_yace\_exporter\_eks\_iam\_role](#module\_prometheus\_yace\_exporter\_eks\_iam\_role) | rallyware/eks-iam-role/aws | 0.3.0 |
| <a name="module_prometheus_yace_exporter_label"></a> [prometheus\_yace\_exporter\_label](#module\_prometheus\_yace\_exporter\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_tempo_eks_iam_role"></a> [tempo\_eks\_iam\_role](#module\_tempo\_eks\_iam\_role) | rallyware/eks-iam-role/aws | 0.3.0 |
| <a name="module_tempo_label"></a> [tempo\_label](#module\_tempo\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_tempo_s3_bucket"></a> [tempo\_s3\_bucket](#module\_tempo\_s3\_bucket) | cloudposse/s3-bucket/aws | 4.2.0 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |
| <a name="module_velero_eks_iam_role"></a> [velero\_eks\_iam\_role](#module\_velero\_eks\_iam\_role) | rallyware/eks-iam-role/aws | 0.3.0 |
| <a name="module_velero_kms_key"></a> [velero\_kms\_key](#module\_velero\_kms\_key) | cloudposse/kms-key/aws | 0.12.2 |
| <a name="module_velero_label"></a> [velero\_label](#module\_velero\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_velero_s3_bucket"></a> [velero\_s3\_bucket](#module\_velero\_s3\_bucket) | cloudposse/s3-bucket/aws | 4.2.0 |

## Resources

| Name | Type |
|------|------|
| [argocd_application.apps](https://registry.terraform.io/providers/argoproj-labs/argocd/latest/docs/resources/application) | resource |
| [argocd_cluster.default](https://registry.terraform.io/providers/argoproj-labs/argocd/latest/docs/resources/cluster) | resource |
| [argocd_project.additional](https://registry.terraform.io/providers/argoproj-labs/argocd/latest/docs/resources/project) | resource |
| [argocd_project.default](https://registry.terraform.io/providers/argoproj-labs/argocd/latest/docs/resources/project) | resource |
| [aws_cloudwatch_event_rule.karpenter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.karpenter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [kubernetes_namespace.linkerd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.linkerd_jaeger](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.linkerd_viz](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.linkerd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.linkerd_jaeger_webhook](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.linkerd_viz_webhook](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.linkerd_webhook](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [tls_private_key.linkerd](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.linkerd](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [aws_caller_identity.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_iam_policy_document.argo_ecr_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.aws_lb_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.chartmuseum](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ebs_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.efs_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.external_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.external_secrets_injector](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.karpenter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.keda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.loki](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.piggy_webhooks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.tempo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.velero](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.yace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [utils_deep_merge_yaml.argocd_helm_apps](https://registry.terraform.io/providers/cloudposse/utils/latest/docs/data-sources/deep_merge_yaml) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks_cluster_id"></a> [eks\_cluster\_id](#input\_eks\_cluster\_id) | EKS cluster ID. | `string` | n/a | yes |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_argocd_additional_projects"></a> [argocd\_additional\_projects](#input\_argocd\_additional\_projects) | A list of additional ArgoCD projects to create. | <pre>list(object(<br>    {<br>      name        = string<br>      description = optional(string, "Managed by Terraform")<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_argocd_app_config"></a> [argocd\_app\_config](#input\_argocd\_app\_config) | A parent app configuration. Required when `argocd_cluster_default_enabled` is `false` | <pre>object(<br>    {<br>      name         = optional(string)<br>      namespace    = optional(string, "argo")<br>      annotations  = optional(map(string))<br>      project      = optional(string)<br>      wait         = optional(bool, false)<br>      sync_options = optional(list(string), ["CreateNamespace=true", "ApplyOutOfSyncOnly=true"])<br><br>      helm = optional(<br>        object(<br>          {<br>            repository = optional(string, "https://rallyware.github.io/terraform-argocd-aws-eks-cluster-bootstrap")<br>            chart      = optional(string, "argocd-app-of-apps")<br>            version    = optional(string, "0.6.2")<br>          }<br>      ), {})<br><br>      timeouts = optional(<br>        object(<br>          {<br>            create = optional(string, "60m")<br>            update = optional(string, "60m")<br>            delete = optional(string, "60m")<br>          }<br>      ), {})<br><br>      retry = optional(<br>        object(<br>          {<br>            limit                = optional(number, 0)<br>            backoff_duration     = optional(string, "30s")<br>            backoff_max_duration = optional(string, "1m")<br>            backoff_factor       = optional(number, 2)<br>          }<br>      ), {})<br><br>      destination = optional(<br>        object(<br>          {<br>            name      = optional(string, "in-cluster")<br>            namespace = optional(string, "argo")<br>          }<br>      ), {})<br><br>      automated = optional(<br>        object(<br>          {<br>            prune       = optional(bool, true)<br>            self_heal   = optional(bool, true)<br>            allow_empty = optional(bool, true)<br>          }<br>      ), {})<br>    }<br>  )</pre> | `{}` | no |
| <a name="input_argocd_apps"></a> [argocd\_apps](#input\_argocd\_apps) | n/a | <pre>list(object(<br>    {<br>      name            = string<br>      repository      = string<br>      version         = string<br>      cluster         = optional(string)<br>      project         = optional(string)<br>      namespace       = optional(string, "default")<br>      chart           = optional(string, "")<br>      path            = optional(string, "")<br>      override_values = optional(string, "")<br>      skip_crds       = optional(bool, false)<br>      value_files     = optional(list(string), [])<br>      max_history     = optional(number, 10)<br>      sync_wave       = optional(number, 50)<br>      annotations     = optional(map(string), {})<br>      sync_options    = optional(list(string), ["CreateNamespace=true", "ApplyOutOfSyncOnly=true"])<br>      omit_finalizer  = optional(bool, false)<br><br>      ignore_differences = optional(<br>        list(object(<br>          {<br>            group             = optional(string)<br>            kind              = optional(string)<br>            jqPathExpressions = optional(list(string))<br>            jsonPointers      = optional(list(string))<br>          }<br>      )), null)<br><br>      retry = optional(<br>        object(<br>          {<br>            limit                = optional(number, 0)<br>            backoff_duration     = optional(string, "30s")<br>            backoff_max_duration = optional(string, "1m")<br>            backoff_factor       = optional(number, 2)<br>          }<br>      ), {})<br><br>      automated = optional(<br>        object(<br>          {<br>            prune       = optional(bool, true)<br>            self_heal   = optional(bool, true)<br>            allow_empty = optional(bool, true)<br>          }<br>      ), {})<br><br>      managed_namespace_metadata = optional(<br>        object(<br>          {<br>            labels      = optional(map(string))<br>            annotations = optional(map(string))<br>          }<br>      ), null)<br><br>      create_default_iam_policy  = optional(bool, true)<br>      create_default_iam_role    = optional(bool, true)<br>      iam_policy_document        = optional(string, "{}")<br>      use_sts_regional_endpoints = optional(bool, true)<br>    }<br>  ))</pre> | <pre>[<br>  {<br>    "chart": "prometheus-operator-crds",<br>    "name": "prometheus-operator-crds",<br>    "namespace": "default",<br>    "repository": "https://prometheus-community.github.io/helm-charts",<br>    "sync_wave": -25,<br>    "version": "0.1.1"<br>  },<br>  {<br>    "chart": "aws-vpc-cni",<br>    "name": "aws-vpc-cni",<br>    "namespace": "kube-system",<br>    "repository": "https://aws.github.io/eks-charts",<br>    "sync_wave": -11,<br>    "version": "1.2.2"<br>  },<br>  {<br>    "chart": "tigera-operator",<br>    "name": "calico",<br>    "namespace": "calico-system",<br>    "repository": "https://docs.projectcalico.org/charts",<br>    "sync_wave": -10,<br>    "version": "v3.20.2"<br>  },<br>  {<br>    "chart": "argo-ecr-auth",<br>    "name": "argo-ecr-auth",<br>    "namespace": "argo",<br>    "repository": "https://sarmad-abualkaz.github.io/my-helm-charts",<br>    "sync_wave": -9,<br>    "version": "0.1.5"<br>  },<br>  {<br>    "chart": "argo-rollouts",<br>    "name": "argo-rollouts",<br>    "namespace": "argo",<br>    "repository": "https://argoproj.github.io/argo-helm",<br>    "version": "2.0.1"<br>  },<br>  {<br>    "chart": "node-local-dns",<br>    "name": "node-local-dns",<br>    "namespace": "kube-system",<br>    "repository": "https://sweetops.github.io/helm-charts",<br>    "sync_wave": -9,<br>    "version": "0.2.1"<br>  },<br>  {<br>    "chart": "cert-manager",<br>    "name": "cert-manager",<br>    "namespace": "cert-manager",<br>    "repository": "https://charts.jetstack.io",<br>    "sync_wave": -7,<br>    "version": "1.5.0"<br>  },<br>  {<br>    "chart": "cert-manager-issuers",<br>    "name": "cert-manager-issuers",<br>    "namespace": "cert-manager",<br>    "repository": "https://charts.adfinis.com",<br>    "sync_wave": -6,<br>    "version": "0.2.2"<br>  },<br>  {<br>    "chart": "aws-load-balancer-controller",<br>    "name": "aws-lb-controller",<br>    "namespace": "kube-system",<br>    "repository": "https://aws.github.io/eks-charts",<br>    "sync_wave": -5,<br>    "version": "1.4.6"<br>  },<br>  {<br>    "chart": "cluster-autoscaler",<br>    "name": "cluster-autoscaler",<br>    "namespace": "kube-system",<br>    "repository": "https://kubernetes.github.io/autoscaler",<br>    "sync_wave": -8,<br>    "version": "9.10.5"<br>  },<br>  {<br>    "chart": "aws-ebs-csi-driver",<br>    "name": "ebs-csi",<br>    "namespace": "csi-drivers",<br>    "repository": "https://kubernetes-sigs.github.io/aws-ebs-csi-driver",<br>    "sync_wave": -5,<br>    "version": "2.16.0"<br>  },<br>  {<br>    "chart": "piggy-webhooks",<br>    "name": "piggy-webhooks",<br>    "namespace": "infra",<br>    "repository": "https://piggysec.com",<br>    "sync_wave": -4,<br>    "version": "0.2.9"<br>  },<br>  {<br>    "chart": "aws-node-termination-handler",<br>    "name": "aws-node-termination-handler",<br>    "namespace": "node-termination-handler",<br>    "repository": "https://aws.github.io/eks-charts",<br>    "version": "0.15.2"<br>  },<br>  {<br>    "chart": "node-problem-detector",<br>    "name": "node-problem-detector",<br>    "namespace": "node-problem-detector",<br>    "repository": "https://charts.deliveryhero.io",<br>    "version": "2.0.5"<br>  },<br>  {<br>    "chart": "ingress-nginx",<br>    "name": "ingress-nginx",<br>    "namespace": "infra",<br>    "repository": "https://kubernetes.github.io/ingress-nginx",<br>    "version": "4.0.1"<br>  },<br>  {<br>    "chart": "velero",<br>    "name": "velero",<br>    "namespace": "velero",<br>    "repository": "https://vmware-tanzu.github.io/helm-charts",<br>    "version": "2.27.0"<br>  },<br>  {<br>    "chart": "keda",<br>    "name": "keda",<br>    "namespace": "infra",<br>    "repository": "https://kedacore.github.io/charts",<br>    "version": "2.13.0"<br>  },<br>  {<br>    "chart": "gatekeeper",<br>    "name": "gatekeeper",<br>    "namespace": "infra",<br>    "repository": "https://open-policy-agent.github.io/gatekeeper/charts",<br>    "version": "3.6.0"<br>  },<br>  {<br>    "chart": "victoria-metrics-k8s-stack",<br>    "name": "victoria-metrics",<br>    "namespace": "monitoring",<br>    "repository": "https://victoriametrics.github.io/helm-charts",<br>    "sync_wave": -3,<br>    "version": "0.5.3"<br>  },<br>  {<br>    "chart": "linkerd-crds",<br>    "ignore_differences": [<br>      {<br>        "group": "apiextensions.k8s.io",<br>        "jsonPointers": [<br>          "/spec/names"<br>        ],<br>        "kind": "CustomResourceDefinition"<br>      }<br>    ],<br>    "name": "linkerd-crds",<br>    "namespace": "linkerd",<br>    "repository": "https://helm.linkerd.io/stable",<br>    "sync_wave": -20,<br>    "version": "1.4.0"<br>  },<br>  {<br>    "chart": "linkerd-helpers",<br>    "name": "linkerd-helpers",<br>    "namespace": "linkerd",<br>    "repository": "https://sweetops.github.io/helm-charts",<br>    "sync_wave": 3,<br>    "version": "0.1.1"<br>  },<br>  {<br>    "chart": "linkerd-control-plane",<br>    "name": "linkerd",<br>    "namespace": "linkerd",<br>    "repository": "https://helm.linkerd.io/stable",<br>    "sync_wave": 4,<br>    "version": "1.9.3"<br>  },<br>  {<br>    "chart": "linkerd-smi",<br>    "name": "linkerd-smi",<br>    "namespace": "linkerd-smi",<br>    "repository": "https://linkerd.github.io/linkerd-smi",<br>    "version": "0.2.0"<br>  },<br>  {<br>    "chart": "linkerd-viz",<br>    "name": "linkerd-viz",<br>    "namespace": "linkerd-viz",<br>    "repository": "https://helm.linkerd.io/stable",<br>    "version": "30.3.3"<br>  },<br>  {<br>    "chart": "linkerd-jaeger",<br>    "name": "linkerd-jaeger",<br>    "namespace": "linkerd-jaeger",<br>    "repository": "https://helm.linkerd.io/stable",<br>    "version": "30.4.3"<br>  },<br>  {<br>    "chart": "prometheus-blackbox-exporter",<br>    "name": "prometheus-blackbox-exporter",<br>    "namespace": "monitoring",<br>    "repository": "https://prometheus-community.github.io/helm-charts",<br>    "version": "5.0.3"<br>  },<br>  {<br>    "chart": "karpenter",<br>    "ignore_differences": [<br>      {<br>        "jsonPointers": [<br>          "/data"<br>        ],<br>        "kind": "Secret"<br>      }<br>    ],<br>    "name": "karpenter",<br>    "namespace": "karpenter",<br>    "repository": "public.ecr.aws/karpenter",<br>    "version": "v0.22.1"<br>  },<br>  {<br>    "chart": "loki",<br>    "ignore_differences": [<br>      {<br>        "group": "apps",<br>        "jqPathExpressions": [<br>          ".spec.persistentVolumeClaimRetentionPolicy"<br>        ],<br>        "kind": "StatefulSet"<br>      }<br>    ],<br>    "name": "loki",<br>    "namespace": "logging",<br>    "repository": "https://grafana.github.io/helm-charts",<br>    "version": "3.6.0"<br>  },<br>  {<br>    "chart": "prometheus-yace-exporter",<br>    "name": "prometheus-yace-exporter",<br>    "namespace": "monitoring",<br>    "repository": "https://mogaal.github.io/helm-charts",<br>    "version": "0.5.0"<br>  },<br>  {<br>    "chart": "tempo-distributed",<br>    "name": "tempo",<br>    "namespace": "tracing",<br>    "repository": "https://grafana.github.io/helm-charts",<br>    "version": "0.15.3"<br>  },<br>  {<br>    "chart": "external-dns",<br>    "name": "external-dns",<br>    "namespace": "infra",<br>    "repository": "https://kubernetes-sigs.github.io/external-dns",<br>    "version": "1.9.0"<br>  },<br>  {<br>    "chart": "actions-runner-controller",<br>    "name": "gha-controller",<br>    "namespace": "cicd",<br>    "repository": "https://actions-runner-controller.github.io/actions-runner-controller",<br>    "sync_wave": 20,<br>    "version": "0.15.1"<br>  },<br>  {<br>    "chart": "github-actions-runners",<br>    "name": "gha-runners",<br>    "namespace": "cicd",<br>    "repository": "https://sweetops.github.io/helm-charts",<br>    "sync_wave": 25,<br>    "version": "0.2.0"<br>  },<br>  {<br>    "chart": "argo-events",<br>    "name": "argo-events",<br>    "namespace": "argo",<br>    "repository": "https://argoproj.github.io/argo-helm",<br>    "version": "1.7.0"<br>  },<br>  {<br>    "chart": "argo-workflows",<br>    "name": "argo-workflows",<br>    "namespace": "argo",<br>    "repository": "https://argoproj.github.io/argo-helm",<br>    "version": "0.5.2"<br>  },<br>  {<br>    "chart": "oauth2-proxy",<br>    "name": "oauth2-proxy",<br>    "namespace": "infra",<br>    "repository": "https://oauth2-proxy.github.io/manifests",<br>    "version": "4.2.0"<br>  },<br>  {<br>    "chart": "aws-efs-csi-driver",<br>    "name": "efs-csi",<br>    "namespace": "csi-drivers",<br>    "repository": "https://kubernetes-sigs.github.io/aws-efs-csi-driver",<br>    "version": "2.4.1"<br>  }<br>]</pre> | no |
| <a name="input_argocd_cluster_default_enabled"></a> [argocd\_cluster\_default\_enabled](#input\_argocd\_cluster\_default\_enabled) | Whether to create ArgoCD cluster resource. Requires: argocd\_iam\_role\_arn | `bool` | `true` | no |
| <a name="input_argocd_iam_role_arn"></a> [argocd\_iam\_role\_arn](#input\_argocd\_iam\_role\_arn) | IAM role ARN for ArgoCD to authenticate in EKS cluster. | `string` | `""` | no |
| <a name="input_argocd_project_default_enabled"></a> [argocd\_project\_default\_enabled](#input\_argocd\_project\_default\_enabled) | Whether to create default ArgoCD project. | `bool` | `true` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_irsa_label_order"></a> [irsa\_label\_order](#input\_irsa\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | <pre>[<br>  "namespace",<br>  "tenant",<br>  "stage",<br>  "attributes"<br>]</pre> | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_argo_ecr_auth_service_account_role_arn"></a> [argo\_ecr\_auth\_service\_account\_role\_arn](#output\_argo\_ecr\_auth\_service\_account\_role\_arn) | argo-ecr-auth IAM role ARN |
| <a name="output_argo_ecr_auth_service_account_role_name"></a> [argo\_ecr\_auth\_service\_account\_role\_name](#output\_argo\_ecr\_auth\_service\_account\_role\_name) | argo-ecr-auth IAM role name |
| <a name="output_argo_ecr_auth_service_account_role_unique_id"></a> [argo\_ecr\_auth\_service\_account\_role\_unique\_id](#output\_argo\_ecr\_auth\_service\_account\_role\_unique\_id) | argo-ecr-auth IAM role unique ID |
| <a name="output_cluster_autoscaler_service_account_policy_id"></a> [cluster\_autoscaler\_service\_account\_policy\_id](#output\_cluster\_autoscaler\_service\_account\_policy\_id) | Cluster-Autoscaler IAM policy ID |
| <a name="output_cluster_autoscaler_service_account_policy_name"></a> [cluster\_autoscaler\_service\_account\_policy\_name](#output\_cluster\_autoscaler\_service\_account\_policy\_name) | Cluster-Autoscaler IAM policy name |
| <a name="output_cluster_autoscaler_service_account_role_arn"></a> [cluster\_autoscaler\_service\_account\_role\_arn](#output\_cluster\_autoscaler\_service\_account\_role\_arn) | Cluster-Autoscaler IAM role ARN |
| <a name="output_cluster_autoscaler_service_account_role_name"></a> [cluster\_autoscaler\_service\_account\_role\_name](#output\_cluster\_autoscaler\_service\_account\_role\_name) | Cluster-Autoscaler IAM role name |
| <a name="output_cluster_autoscaler_service_account_role_unique_id"></a> [cluster\_autoscaler\_service\_account\_role\_unique\_id](#output\_cluster\_autoscaler\_service\_account\_role\_unique\_id) | Cluster-Autoscaler IAM role unique ID |
| <a name="output_ebs_csi_kms_key_arn"></a> [ebs\_csi\_kms\_key\_arn](#output\_ebs\_csi\_kms\_key\_arn) | EBS CSI KMS key ARN |
| <a name="output_ebs_csi_kms_key_id"></a> [ebs\_csi\_kms\_key\_id](#output\_ebs\_csi\_kms\_key\_id) | EBS CSI KMS key ID |
| <a name="output_ebs_csi_service_account_policy_id"></a> [ebs\_csi\_service\_account\_policy\_id](#output\_ebs\_csi\_service\_account\_policy\_id) | EBS CSI driver IAM policy ID |
| <a name="output_ebs_csi_service_account_policy_name"></a> [ebs\_csi\_service\_account\_policy\_name](#output\_ebs\_csi\_service\_account\_policy\_name) | EBS CSI driver IAM policy name |
| <a name="output_ebs_csi_service_account_role_arn"></a> [ebs\_csi\_service\_account\_role\_arn](#output\_ebs\_csi\_service\_account\_role\_arn) | EBS CSI driver IAM role ARN |
| <a name="output_ebs_csi_service_account_role_name"></a> [ebs\_csi\_service\_account\_role\_name](#output\_ebs\_csi\_service\_account\_role\_name) | EBS CSI driver IAM role name |
| <a name="output_ebs_csi_service_account_role_unique_id"></a> [ebs\_csi\_service\_account\_role\_unique\_id](#output\_ebs\_csi\_service\_account\_role\_unique\_id) | EBS CSI driver IAM role unique ID |
| <a name="output_efs_csi_service_account_policy_id"></a> [efs\_csi\_service\_account\_policy\_id](#output\_efs\_csi\_service\_account\_policy\_id) | EFS CSI driver IAM policy ID |
| <a name="output_efs_csi_service_account_policy_name"></a> [efs\_csi\_service\_account\_policy\_name](#output\_efs\_csi\_service\_account\_policy\_name) | EFS CSI driver IAM policy name |
| <a name="output_efs_csi_service_account_role_arn"></a> [efs\_csi\_service\_account\_role\_arn](#output\_efs\_csi\_service\_account\_role\_arn) | EFS CSI driver IAM role ARN |
| <a name="output_efs_csi_service_account_role_name"></a> [efs\_csi\_service\_account\_role\_name](#output\_efs\_csi\_service\_account\_role\_name) | EFS CSI driver IAM role name |
| <a name="output_efs_csi_service_account_role_unique_id"></a> [efs\_csi\_service\_account\_role\_unique\_id](#output\_efs\_csi\_service\_account\_role\_unique\_id) | EFS CSI driver IAM role unique ID |
| <a name="output_external_secrets_injector_role_arn"></a> [external\_secrets\_injector\_role\_arn](#output\_external\_secrets\_injector\_role\_arn) | The External-secrets injector IAM role ARN |
| <a name="output_external_secrets_service_account_policy_id"></a> [external\_secrets\_service\_account\_policy\_id](#output\_external\_secrets\_service\_account\_policy\_id) | The External-secrets IAM policy ID |
| <a name="output_external_secrets_service_account_policy_name"></a> [external\_secrets\_service\_account\_policy\_name](#output\_external\_secrets\_service\_account\_policy\_name) | The External-secrets operator IAM policy name |
| <a name="output_external_secrets_service_account_role_arn"></a> [external\_secrets\_service\_account\_role\_arn](#output\_external\_secrets\_service\_account\_role\_arn) | The External-secrets operator IAM role ARN |
| <a name="output_external_secrets_service_account_role_name"></a> [external\_secrets\_service\_account\_role\_name](#output\_external\_secrets\_service\_account\_role\_name) | The External-secrets operator IAM role name |
| <a name="output_external_secrets_service_account_role_unique_id"></a> [external\_secrets\_service\_account\_role\_unique\_id](#output\_external\_secrets\_service\_account\_role\_unique\_id) | The External-secrets operator IAM role unique ID |
| <a name="output_karpenter_instance_profile_arn"></a> [karpenter\_instance\_profile\_arn](#output\_karpenter\_instance\_profile\_arn) | The Karpenter Instance Profile ARN |
| <a name="output_karpenter_instance_profile_id"></a> [karpenter\_instance\_profile\_id](#output\_karpenter\_instance\_profile\_id) | The Karpenter Instance Profile ID |
| <a name="output_karpenter_instance_profile_name"></a> [karpenter\_instance\_profile\_name](#output\_karpenter\_instance\_profile\_name) | The name of Karpenter Instance Profile |
| <a name="output_karpenter_service_account_policy_id"></a> [karpenter\_service\_account\_policy\_id](#output\_karpenter\_service\_account\_policy\_id) | AWS Karpenter IAM policy ID |
| <a name="output_karpenter_service_account_policy_name"></a> [karpenter\_service\_account\_policy\_name](#output\_karpenter\_service\_account\_policy\_name) | AWS Karpenter IAM policy name |
| <a name="output_karpenter_service_account_role_arn"></a> [karpenter\_service\_account\_role\_arn](#output\_karpenter\_service\_account\_role\_arn) | AWS Karpenter IAM role ARN |
| <a name="output_karpenter_service_account_role_name"></a> [karpenter\_service\_account\_role\_name](#output\_karpenter\_service\_account\_role\_name) | AWS Karpenter IAM role name |
| <a name="output_karpenter_service_account_role_unique_id"></a> [karpenter\_service\_account\_role\_unique\_id](#output\_karpenter\_service\_account\_role\_unique\_id) | AWS Karpenter IAM role unique ID |
| <a name="output_keda_service_account_policy_id"></a> [keda\_service\_account\_policy\_id](#output\_keda\_service\_account\_policy\_id) | KEDA AWS IAM policy ID |
| <a name="output_keda_service_account_policy_name"></a> [keda\_service\_account\_policy\_name](#output\_keda\_service\_account\_policy\_name) | KEDA AWS IAM policy name |
| <a name="output_keda_service_account_role_arn"></a> [keda\_service\_account\_role\_arn](#output\_keda\_service\_account\_role\_arn) | KEDA AWS IAM role ARN |
| <a name="output_keda_service_account_role_name"></a> [keda\_service\_account\_role\_name](#output\_keda\_service\_account\_role\_name) | Keda AWS IAM role name |
| <a name="output_keda_service_account_role_unique_id"></a> [keda\_service\_account\_role\_unique\_id](#output\_keda\_service\_account\_role\_unique\_id) | KEDA AWS IAM role unique ID |
| <a name="output_loki_s3_bucket_arn"></a> [loki\_s3\_bucket\_arn](#output\_loki\_s3\_bucket\_arn) | Grafana Loki S3 bucket ARN |
| <a name="output_loki_s3_bucket_id"></a> [loki\_s3\_bucket\_id](#output\_loki\_s3\_bucket\_id) | Grafana Loki S3 bucket name |
| <a name="output_loki_service_account_policy_id"></a> [loki\_service\_account\_policy\_id](#output\_loki\_service\_account\_policy\_id) | Grafana Loki IAM policy ID |
| <a name="output_loki_service_account_policy_name"></a> [loki\_service\_account\_policy\_name](#output\_loki\_service\_account\_policy\_name) | Grafana Loki IAM policy name |
| <a name="output_loki_service_account_role_arn"></a> [loki\_service\_account\_role\_arn](#output\_loki\_service\_account\_role\_arn) | Grafana Loki IAM role ARN |
| <a name="output_loki_service_account_role_name"></a> [loki\_service\_account\_role\_name](#output\_loki\_service\_account\_role\_name) | Grafana Loki IAM role name |
| <a name="output_loki_service_account_role_unique_id"></a> [loki\_service\_account\_role\_unique\_id](#output\_loki\_service\_account\_role\_unique\_id) | Grafana Loki IAM role unique ID |
| <a name="output_piggy_webhooks_service_account_policy_id"></a> [piggy\_webhooks\_service\_account\_policy\_id](#output\_piggy\_webhooks\_service\_account\_policy\_id) | Piggy webhooks IAM policy ID |
| <a name="output_piggy_webhooks_service_account_policy_name"></a> [piggy\_webhooks\_service\_account\_policy\_name](#output\_piggy\_webhooks\_service\_account\_policy\_name) | Piggy webhooks IAM policy name |
| <a name="output_piggy_webhooks_service_account_role_arn"></a> [piggy\_webhooks\_service\_account\_role\_arn](#output\_piggy\_webhooks\_service\_account\_role\_arn) | Piggy webhooks IAM role ARN |
| <a name="output_piggy_webhooks_service_account_role_name"></a> [piggy\_webhooks\_service\_account\_role\_name](#output\_piggy\_webhooks\_service\_account\_role\_name) | Piggy webhooks IAM role name |
| <a name="output_piggy_webhooks_service_account_role_unique_id"></a> [piggy\_webhooks\_service\_account\_role\_unique\_id](#output\_piggy\_webhooks\_service\_account\_role\_unique\_id) | Piggy webhooks IAM role unique ID |
| <a name="output_prometheus_yace_exporter_service_account_role_arn"></a> [prometheus\_yace\_exporter\_service\_account\_role\_arn](#output\_prometheus\_yace\_exporter\_service\_account\_role\_arn) | prometheus-yace-exporter IAM role ARN |
| <a name="output_prometheus_yace_exporter_service_account_role_name"></a> [prometheus\_yace\_exporter\_service\_account\_role\_name](#output\_prometheus\_yace\_exporter\_service\_account\_role\_name) | prometheus-yace-exporter IAM role name |
| <a name="output_prometheus_yace_exporter_service_account_role_unique_id"></a> [prometheus\_yace\_exporter\_service\_account\_role\_unique\_id](#output\_prometheus\_yace\_exporter\_service\_account\_role\_unique\_id) | prometheus-yace-exporter IAM role unique ID |
| <a name="output_tempo_s3_bucket_arn"></a> [tempo\_s3\_bucket\_arn](#output\_tempo\_s3\_bucket\_arn) | Grafana Tempo S3 bucket ARN |
| <a name="output_tempo_s3_bucket_id"></a> [tempo\_s3\_bucket\_id](#output\_tempo\_s3\_bucket\_id) | Grafana Tempo S3 bucket name |
| <a name="output_tempo_service_account_policy_id"></a> [tempo\_service\_account\_policy\_id](#output\_tempo\_service\_account\_policy\_id) | Grafana Tempo IAM policy ID |
| <a name="output_tempo_service_account_policy_name"></a> [tempo\_service\_account\_policy\_name](#output\_tempo\_service\_account\_policy\_name) | Grafana Tempo IAM policy name |
| <a name="output_tempo_service_account_role_arn"></a> [tempo\_service\_account\_role\_arn](#output\_tempo\_service\_account\_role\_arn) | Grafana Tempo IAM role ARN |
| <a name="output_tempo_service_account_role_name"></a> [tempo\_service\_account\_role\_name](#output\_tempo\_service\_account\_role\_name) | Grafana Tempo IAM role name |
| <a name="output_tempo_service_account_role_unique_id"></a> [tempo\_service\_account\_role\_unique\_id](#output\_tempo\_service\_account\_role\_unique\_id) | Grafana Tempo IAM role unique ID |
| <a name="output_velero_kms_key_arn"></a> [velero\_kms\_key\_arn](#output\_velero\_kms\_key\_arn) | Velero KMS key ARN |
| <a name="output_velero_kms_key_id"></a> [velero\_kms\_key\_id](#output\_velero\_kms\_key\_id) | Velero KMS key ID |
| <a name="output_velero_s3_bucket_arn"></a> [velero\_s3\_bucket\_arn](#output\_velero\_s3\_bucket\_arn) | Velero S3 bucket ARN |
| <a name="output_velero_s3_bucket_id"></a> [velero\_s3\_bucket\_id](#output\_velero\_s3\_bucket\_id) | Velero S3 bucket name |
| <a name="output_velero_service_account_policy_id"></a> [velero\_service\_account\_policy\_id](#output\_velero\_service\_account\_policy\_id) | Velero IAM policy ID |
| <a name="output_velero_service_account_policy_name"></a> [velero\_service\_account\_policy\_name](#output\_velero\_service\_account\_policy\_name) | Velero IAM policy name |
| <a name="output_velero_service_account_role_arn"></a> [velero\_service\_account\_role\_arn](#output\_velero\_service\_account\_role\_arn) | Velero IAM role ARN |
| <a name="output_velero_service_account_role_name"></a> [velero\_service\_account\_role\_name](#output\_velero\_service\_account\_role\_name) | Velero IAM role name |
| <a name="output_velero_service_account_role_unique_id"></a> [velero\_service\_account\_role\_unique\_id](#output\_velero\_service\_account\_role\_unique\_id) | Velero IAM role unique ID |
<!-- END_TF_DOCS --> 

## License
The Apache-2.0 license