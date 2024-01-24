locals {
  keda_enabled             = module.this.enabled && contains(local.argocd_helm_apps_enabled, "keda")
  keda_iam_role_enabled    = local.keda_enabled ? local.argocd_helm_apps_set["keda"]["create_default_iam_role"] : false
  keda_iam_policy_enabled  = local.keda_enabled ? local.argocd_helm_apps_set["keda"]["create_default_iam_policy"] : false
  keda_iam_policy_document = local.keda_iam_policy_enabled ? one(data.aws_iam_policy_document.keda[*].json) : try(local.argocd_helm_apps_set["keda"]["iam_policy_document"], "{}")
}

module "keda_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.keda_iam_role_enabled
  context = module.this.context
}

module "keda_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.2.1"

  aws_iam_policy_document     = local.keda_iam_policy_document
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = try(local.argocd_helm_apps_set["keda"]["name"], "")
  service_account_namespace   = try(local.argocd_helm_apps_set["keda"]["namespace"], "")

  label_order = var.irsa_label_order
  context     = module.keda_label.context
}