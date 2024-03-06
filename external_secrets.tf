locals {
  external_secrets_enabled                    = module.this.enabled && contains(local.argocd_helm_apps_enabled, "external-secrets")
  external_secrets_iam_role_enabled           = local.external_secrets_enabled ? local.argocd_helm_apps_set["external-secrets"]["create_default_iam_role"] : false
  external_secrets_iam_policy_enabled         = local.external_secrets_enabled ? local.argocd_helm_apps_set["external-secrets"]["create_default_iam_policy"] : false
  external_secrets_iam_policy_document        = local.external_secrets_iam_policy_enabled ? one(data.aws_iam_policy_document.external_secrets[*].json) : try(local.argocd_helm_apps_set["external-secrets"]["iam_policy_document"], "{}")
  external_secrets_use_sts_regional_endpoints = local.external_secrets_enabled ? local.argocd_helm_apps_set["external-secrets"]["use_sts_regional_endpoints"] : false
}

module "external_secrets_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.external_secrets_iam_role_enabled
  context = module.this.context
}

data "aws_iam_policy_document" "external_secrets" {
  count = local.external_secrets_iam_role_enabled ? (local.external_secrets_iam_policy_enabled ? 1 : 0) : 0

  statement {
    effect = "Allow"

    resources = [module.external_secrets_injector_role.arn]

    actions = [
      "sts:AssumeRole"
    ]
  }
}

data "aws_iam_policy_document" "external_secrets_injector" {
  count = local.external_secrets_iam_role_enabled ? (local.external_secrets_iam_policy_enabled ? 1 : 0) : 0

  statement {
    effect = "Allow"

    resources = ["*"]

    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:ListSecrets"
    ]
  }

  statement {
    effect = "Allow"

    resources = ["*"]

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
  }

  statement {
    effect = "Allow"

    resources = ["*"]

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability"
    ]
  }
}

module "external_secrets_injector_role" {
  source  = "cloudposse/iam-role/aws"
  version = "0.19.0"

  role_description = "Allows external-secrets to access AWS resources"

  principals = {
    AWS = [
      module.external_secrets_eks_iam_role.service_account_role_arn
    ]
  }

  policy_documents = [
    one(data.aws_iam_policy_document.external_secrets_injector[*].json)
  ]

  assume_role_actions = [
    "sts:AssumeRole"
  ]

  name        = local.eks_cluster_id
  attributes  = ["secrets-injector"]
  label_order = ["name", "attributes"]
  context     = module.external_secrets_label.context
}

module "external_secrets_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.3.0"

  aws_iam_policy_document     = local.external_secrets_iam_policy_document
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = "xt-scrts"
  service_account_namespace   = try(local.argocd_helm_apps_set["external-secrets"]["namespace"], "")

  label_order = var.irsa_label_order
  context     = module.external_secrets_label.context
}
