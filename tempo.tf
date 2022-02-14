locals {
  tempo_enabled                    = module.this.enabled && contains(local.argocd_helm_apps_enabled, "tempo")
  tempo_iam_role_enabled           = local.tempo_enabled ? local.argocd_helm_apps_set["tempo"]["create_default_iam_role"] : false
  tempo_iam_policy_enabled         = local.tempo_enabled ? local.argocd_helm_apps_set["tempo"]["create_default_iam_policy"] : false
  tempo_iam_policy_document        = local.tempo_iam_policy_enabled ? one(data.aws_iam_policy_document.tempo[*].json) : try(local.argocd_helm_apps_set["tempo"]["iam_policy_document"], "{}")
  tempo_use_sts_regional_endpoints = local.tempo_enabled ? local.argocd_helm_apps_set["tempo"]["use_sts_regional_endpoints"] : false
}

module "tempo_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.tempo_iam_role_enabled
  context = module.this.context
}

module "tempo_s3_bucket" {
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

  name    = "tempo"
  context = module.tempo_label.context
}

data "aws_iam_policy_document" "tempo" {
  count = local.tempo_iam_role_enabled ? (local.tempo_iam_policy_enabled ? 1 : 0) : 0

  statement {
    effect = "Allow"

    resources = [
      format("%s/*", module.tempo_s3_bucket.bucket_arn),
      module.tempo_s3_bucket.bucket_arn
    ]

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject",
      "s3:GetObjectTagging",
      "s3:PutObjectTagging"
    ]
  }
}

module "tempo_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.1.1"

  aws_iam_policy_document     = one(data.aws_iam_policy_document.tempo[*].json)
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = try(local.argocd_helm_apps_set["tempo"]["name"], "")
  service_account_namespace   = try(local.argocd_helm_apps_set["tempo"]["namespace"], "")

  context = module.tempo_label.context
}
