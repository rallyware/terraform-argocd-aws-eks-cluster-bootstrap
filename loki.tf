locals {
  loki_enabled                    = module.this.enabled && contains(local.argocd_helm_apps_enabled, "loki")
  loki_iam_role_enabled           = local.loki_enabled ? local.argocd_helm_apps_set["loki"]["create_default_iam_role"] : false
  loki_iam_policy_enabled         = local.loki_enabled ? local.argocd_helm_apps_set["loki"]["create_default_iam_policy"] : false
  loki_iam_policy_document        = local.loki_iam_policy_enabled ? one(data.aws_iam_policy_document.loki[*].json) : try(local.argocd_helm_apps_set["loki"]["iam_policy_document"], "{}")
  loki_use_sts_regional_endpoints = local.loki_enabled ? local.argocd_helm_apps_set["loki"]["use_sts_regional_endpoints"] : false
}


module "loki_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.loki_iam_role_enabled
  context = module.this.context
}

module "loki_s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "3.0.0"

  acl                 = "private"
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  force_destroy       = true
  user_enabled        = false
  versioning_enabled  = false
  sse_algorithm       = "AES256"

  name    = "loki"
  context = module.loki_label.context
}

data "aws_iam_policy_document" "loki" {
  count = local.loki_iam_role_enabled ? (local.loki_iam_policy_enabled ? 1 : 0) : 0

  statement {
    effect = "Allow"

    resources = [
      format("%s/*", module.loki_s3_bucket.bucket_arn),
      module.loki_s3_bucket.bucket_arn
    ]

    actions = [
      "s3:ListObjects",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
  }
}

module "loki_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.2.1"

  aws_iam_policy_document     = local.loki_iam_policy_document
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = try(local.argocd_helm_apps_set["loki"]["name"], "")
  service_account_namespace   = try(local.argocd_helm_apps_set["loki"]["namespace"], "")

  label_order = var.irsa_label_order
  context     = module.loki_label.context
}
