locals {
  yace_enabled                    = module.this.enabled && contains(local.argocd_helm_apps_enabled, "yace")
  yace_iam_role_enabled           = local.yace_enabled ? local.argocd_helm_apps_set["yace"]["create_default_iam_role"] : false
  yace_iam_policy_enabled         = local.yace_enabled ? local.argocd_helm_apps_set["yace"]["create_default_iam_policy"] : false
  yace_iam_policy_document        = local.yace_iam_policy_enabled ? one(data.aws_iam_policy_document.yace[*].json) : try(local.argocd_helm_apps_set["yace"]["iam_policy_document"], "{}")
  yace_use_sts_regional_endpoints = local.yace_enabled ? local.argocd_helm_apps_set["yace"]["use_sts_regional_endpoints"] : false
}

module "yace_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.yace_iam_role_enabled
  context = module.this.context
}

data "aws_iam_policy_document" "yace" {
  count = local.yace_iam_role_enabled ? (local.yace_iam_policy_enabled ? 1 : 0) : 0

  statement {
    resources = [ "*" ]
    effect = "Allow"
    actions = [ 
      "tag:GetResources",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics"
    ]
  }
}

module "yace_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.1.1"

  aws_iam_policy_document     = one(data.aws_iam_policy_document.yace[*].json)
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = try(local.argocd_helm_apps_set["yace"]["name"], "")
  service_account_namespace   = try(local.argocd_helm_apps_set["yace"]["namespace"], "")

  context = module.yace_label.context
}
