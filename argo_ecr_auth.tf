locals {
  argo_ecr_auth_enabled                    = module.this.enabled && contains(local.argocd_helm_apps_enabled, "argo-ecr-auth")
  argo_ecr_auth_iam_role_enabled           = local.argo_ecr_auth_enabled ? local.argocd_helm_apps_set["argo-ecr-auth"]["create_default_iam_role"] : false
  argo_ecr_auth_iam_policy_enabled         = local.argo_ecr_auth_enabled ? local.argocd_helm_apps_set["argo-ecr-auth"]["create_default_iam_policy"] : false
  argo_ecr_auth_iam_policy_document        = local.argo_ecr_auth_iam_policy_enabled ? one(data.aws_iam_policy_document.argo_ecr_auth[*].json) : try(local.argocd_helm_apps_set["argo-ecr-auth"]["iam_policy_document"], "{}")
  argo_ecr_auth_use_sts_regional_endpoints = local.argo_ecr_auth_enabled ? local.argocd_helm_apps_set["argo-ecr-auth"]["use_sts_regional_endpoints"] : false
}


module "argo_ecr_auth_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.argo_ecr_auth_iam_role_enabled
  context = module.this.context
}


data "aws_iam_policy_document" "argo_ecr_auth" {
  count = local.argo_ecr_auth_enabled ? 1 : 0

  statement {
    sid    = "ECRReadOnly"
    effect = "Allow"

    resources = ["*"]

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:ListTagsForResource",
      "ecr:DescribeImageScanFindings"
    ]
  }
}

module "argo_ecr_auth_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.1.2"

  aws_iam_policy_document     = local.argo_ecr_auth_iam_policy_document
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = try(local.argocd_helm_apps_set["argo-ecr-auth"]["name"], "")
  service_account_namespace   = try(local.argocd_helm_apps_set["argo-ecr-auth"]["namespace"], "")

  context = module.argo_ecr_auth_label.context
}
