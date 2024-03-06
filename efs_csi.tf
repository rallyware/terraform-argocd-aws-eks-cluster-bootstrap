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
}

module "efs_csi_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.3.0"

  aws_iam_policy_document     = local.efs_csi_iam_policy_document
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = "efs-csi-controller-sa"
  service_account_namespace   = try(local.argocd_helm_apps_set["efs-csi"]["namespace"], "")

  label_order = var.irsa_label_order
  context     = module.efs_csi_label.context
}
