locals {
  velero_enabled                    = module.this.enabled && contains(local.argocd_helm_apps_enabled, "velero")
  velero_iam_role_enabled           = local.velero_enabled ? local.argocd_helm_apps_set["velero"]["create_default_iam_role"] : false
  velero_iam_policy_enabled         = local.velero_enabled ? local.argocd_helm_apps_set["velero"]["create_default_iam_policy"] : false
  velero_iam_policy_document        = local.velero_iam_policy_enabled ? one(data.aws_iam_policy_document.velero[*].json) : try(local.argocd_helm_apps_set["velero"]["iam_policy_document"], "{}")
  velero_use_sts_regional_endpoints = local.velero_enabled ? local.argocd_helm_apps_set["velero"]["use_sts_regional_endpoints"] : false
}

module "velero_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.velero_iam_role_enabled
  context = module.this.context
}

module "velero_kms_key" {
  source  = "cloudposse/kms-key/aws"
  version = "0.12.1"

  description             = format("KMS key for Velero on %s", local.eks_cluster_id)
  deletion_window_in_days = 10
  enable_key_rotation     = true
  alias                   = format("alias/%s/velero", local.eks_cluster_id)

  name    = "velero"
  context = module.velero_label.context
}

module "velero_s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "0.44.1"

  acl                 = "private"
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  user_enabled        = false
  versioning_enabled  = false
  sse_algorithm       = "aws:kms"
  kms_master_key_arn  = module.velero_kms_key.key_arn

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

  name    = "velero"
  context = module.velero_label.context
}

data "aws_iam_policy_document" "velero" {
  count = local.velero_iam_role_enabled ? (local.velero_iam_policy_enabled ? 1 : 0) : 0

  statement {
    effect = "Allow"

    resources = [
      format("%s/*", module.velero_s3_bucket.bucket_arn),
      module.velero_s3_bucket.bucket_arn
    ]

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts"
    ]
  }

  statement {
    effect = "Allow"

    resources = [
      module.velero_kms_key.key_arn
    ]

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot"
    ]
  }
}

module "velero_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.1.1"

  aws_iam_policy_document     = local.velero_iam_policy_document
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = try(local.argocd_helm_apps_set["velero"]["name"], "")
  service_account_namespace   = try(local.argocd_helm_apps_set["velero"]["namespace"], "")

  context = module.velero_label.context
}
