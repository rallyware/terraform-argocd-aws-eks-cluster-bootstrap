locals {
  piggy_webhooks_enabled                    = module.this.enabled && contains(local.argocd_helm_apps_enabled, "piggy-webhooks")
  piggy_webhooks_iam_role_enabled           = local.piggy_webhooks_enabled ? local.argocd_helm_apps_set["piggy-webhooks"]["create_default_iam_role"] : false
  piggy_webhooks_iam_policy_enabled         = local.piggy_webhooks_enabled ? local.argocd_helm_apps_set["piggy-webhooks"]["create_default_iam_policy"] : false
  piggy_webhooks_iam_policy_document        = local.piggy_webhooks_iam_policy_enabled ? one(data.aws_iam_policy_document.piggy_webhooks[*].json) : try(local.argocd_helm_apps_set["piggy-webhooks"]["iam_policy_document"], "{}")
  piggy_webhooks_use_sts_regional_endpoints = local.velero_enabled ? local.argocd_helm_apps_set["piggy-webhooks"]["use_sts_regional_endpoints"] : false
}

data "aws_iam_policy_document" "piggy_webhooks" {
  count = local.piggy_webhooks_iam_role_enabled ? (local.piggy_webhooks_iam_policy_enabled ? 1 : 0) : 0

  statement {
    sid       = "PiggySecretReadOnly"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:ListSecrets"
    ]
  }

  statement {
    sid       = "PiggyECRReadOnly"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer"
    ]
  }

  statement {
    sid       = "PiggyKMSDecrypt"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "kms:Decrypt"
    ]
  }
}

module "piggy_webhooks_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.piggy_webhooks_iam_role_enabled
  context = module.this.context
}

module "piggy_webhooks_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.2.1"

  aws_iam_policy_document     = local.piggy_webhooks_iam_policy_document
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = try(local.argocd_helm_apps_set["piggy-webhooks"]["name"], "")
  service_account_namespace   = try(local.argocd_helm_apps_set["piggy-webhooks"]["namespace"], "")

  label_order = var.irsa_label_order
  context     = module.piggy_webhooks_label.context
}
