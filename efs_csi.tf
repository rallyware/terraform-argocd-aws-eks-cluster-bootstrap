locals {
  efs_csi_enabled                    = module.this.enabled && contains(local.argocd_helm_apps_enabled, "efs-csi")
  efs_csi_iam_role_enabled           = local.efs_csi_enabled ? local.argocd_helm_apps_set["efs-csi"]["create_default_iam_role"] : false
  efs_csi_iam_policy_enabled         = local.efs_csi_enabled ? local.argocd_helm_apps_set["efs-csi"]["create_default_iam_policy"] : false
  efs_csi_iam_policy_document        = local.efs_csi_iam_policy_enabled ? one(data.aws_iam_policy_document.efs_csi[*].json) : try(local.argocd_helm_apps_set["efs-csi"]["iam_policy_document"], "{}")
  efs_csi_use_sts_regional_endpoints = local.efs_csi_enabled ? local.argocd_helm_apps_set["efs-csi"]["use_sts_regional_endpoints"] : false
}

module "efs_csi_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.efs_csi_iam_role_enabled
  context = module.this.context
}

module "efs_csi_kms_key" {
  source  = "cloudposse/kms-key/aws"
  version = "0.12.1"

  description             = format("KMS key for efs-csi on %s", local.eks_cluster_id)
  deletion_window_in_days = 10
  enable_key_rotation     = true
  alias                   = format("alias/%s/efs-csi", local.eks_cluster_id)

  name       = "efs"
  attributes = ["csi"]
  context    = module.efs_csi_label.context
}

data "aws_iam_policy_document" "efs_csi" {
  count = local.efs_csi_iam_role_enabled ? (local.efs_csi_iam_policy_enabled ? 1 : 0) : 0

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticfilesystem:DescribeAccessPoints",
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:DescribeMountTargets",
      "ec2:DescribeAvailabilityZones"
    ]
  }

  statement {
    effect = "Allow"

    resources = ["*"]

    actions = ["elasticfilesystem:CreateAccessPoint"]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/efs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }

  statement {
    effect = "Allow"

    resources = ["*"]

    actions = ["elasticfilesystem:TagResource"]

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/efs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }

  statement {
    effect = "Allow"

    resources = ["*"]

    actions = ["elasticfilesystem:DeleteAccessPoint"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/efs.csi.aws.com/cluster"

      values = ["true"]
    }
  }

  statement {
    effect = "Allow"
    resources = [
      module.efs_csi_kms_key.key_arn
    ]

    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant",
    ]

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }

  statement {
    effect = "Allow"
    resources = [
      module.efs_csi_kms_key.key_arn
    ]


    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
  }
}

module "efs_csi_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.1.2"

  aws_iam_policy_document     = local.efs_csi_iam_policy_document
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = "efs-csi-controller-sa"
  service_account_namespace   = try(local.argocd_helm_apps_set["efs-csi"]["namespace"], "")

  label_order = var.irsa_label_order
  context     = module.efs_csi_label.context
}
