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
  version = "0.46.0"

  acl                 = "private"
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  user_enabled        = false
  versioning_enabled  = false
  sse_algorithm       = "AES256"

  lifecycle_rules = [
    {
      enabled = false
      prefix  = ""
      tags    = {}

      enable_glacier_transition            = false
      enable_deeparchive_transition        = false
      enable_standard_ia_transition        = false
      enable_current_object_expiration     = false
      enable_noncurrent_version_expiration = false

      abort_incomplete_multipart_upload_days         = 90
      noncurrent_version_glacier_transition_days     = 30
      noncurrent_version_deeparchive_transition_days = 60
      noncurrent_version_expiration_days             = 90

      standard_transition_days    = 30
      glacier_transition_days     = 60
      deeparchive_transition_days = 90
      expiration_days             = 90
    }
  ]

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
  version = "0.1.1"

  aws_iam_policy_document     = one(data.aws_iam_policy_document.loki[*].json)
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = try(local.argocd_helm_apps_set["loki"]["name"], "")
  service_account_namespace   = try(local.argocd_helm_apps_set["loki"]["namespace"], "")

  context = module.loki_label.context
}

module "loki_compactor_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.1.1"

  aws_iam_policy_document     = one(data.aws_iam_policy_document.loki[*].json)
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = format("%s-%s", try(local.argocd_helm_apps_set["loki"]["name"], ""), "compactor")
  service_account_namespace   = try(local.argocd_helm_apps_set["loki"]["namespace"], "")

  context = module.loki_label.context
}
