locals {
  prometheus_yace_exporter_enabled                    = module.this.enabled && contains(local.argocd_helm_apps_enabled, "prometheus-yace-exporter")
  prometheus_yace_exporter_iam_role_enabled           = local.prometheus_yace_exporter_enabled ? local.argocd_helm_apps_set["prometheus-yace-exporter"]["create_default_iam_role"] : false
  prometheus_yace_exporter_iam_policy_enabled         = local.prometheus_yace_exporter_enabled ? local.argocd_helm_apps_set["prometheus-yace-exporter"]["create_default_iam_policy"] : false
  prometheus_yace_exporter_iam_policy_document        = local.prometheus_yace_exporter_iam_policy_enabled ? one(data.aws_iam_policy_document.yace[*].json) : try(local.argocd_helm_apps_set["prometheus-yace-exporter"]["iam_policy_document"], "{}")
  prometheus_yace_exporter_use_sts_regional_endpoints = local.prometheus_yace_exporter_enabled ? local.argocd_helm_apps_set["prometheus-yace-exporter"]["use_sts_regional_endpoints"] : false
}

module "prometheus_yace_exporter_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.prometheus_yace_exporter_iam_role_enabled
  context = module.this.context
}

data "aws_iam_policy_document" "yace" {
  count = local.prometheus_yace_exporter_iam_role_enabled ? (local.prometheus_yace_exporter_iam_policy_enabled ? 1 : 0) : 0

  statement {
    resources = ["*"]
    effect    = "Allow"
    actions = [
      "tag:GetResources",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics"
    ]
  }
}

module "prometheus_yace_exporter_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.3.0"

  aws_iam_policy_document     = local.prometheus_yace_exporter_iam_policy_document
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = try(local.argocd_helm_apps_set["prometheus-yace-exporter"]["name"], "")
  service_account_namespace   = try(local.argocd_helm_apps_set["prometheus-yace-exporter"]["namespace"], "")

  label_order = var.irsa_label_order
  context     = module.prometheus_yace_exporter_label.context
}
