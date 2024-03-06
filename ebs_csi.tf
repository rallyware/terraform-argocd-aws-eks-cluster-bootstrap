locals {
  ebs_csi_enabled                    = module.this.enabled && contains(local.argocd_helm_apps_enabled, "ebs-csi")
  ebs_csi_iam_role_enabled           = local.ebs_csi_enabled ? local.argocd_helm_apps_set["ebs-csi"]["create_default_iam_role"] : false
  ebs_csi_iam_policy_enabled         = local.ebs_csi_enabled ? local.argocd_helm_apps_set["ebs-csi"]["create_default_iam_policy"] : false
  ebs_csi_iam_policy_document        = local.ebs_csi_iam_policy_enabled ? one(data.aws_iam_policy_document.ebs_csi[*].json) : try(local.argocd_helm_apps_set["ebs-csi"]["iam_policy_document"], "{}")
  ebs_csi_use_sts_regional_endpoints = local.ebs_csi_enabled ? local.argocd_helm_apps_set["ebs-csi"]["use_sts_regional_endpoints"] : false
}

module "ebs_csi_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.ebs_csi_iam_role_enabled
  context = module.this.context
}

module "ebs_csi_kms_key" {
  source  = "cloudposse/kms-key/aws"
  version = "0.12.2"

  description             = format("KMS key for ebs-csi on %s", local.eks_cluster_id)
  deletion_window_in_days = 10
  enable_key_rotation     = true
  alias                   = format("alias/%s/ebs-csi", local.eks_cluster_id)

  name       = "ebs"
  attributes = ["csi"]
  context    = module.ebs_csi_label.context
}

data "aws_iam_policy_document" "ebs_csi" {
  count = local.ebs_csi_iam_role_enabled ? (local.ebs_csi_iam_policy_enabled ? 1 : 0) : 0

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:CreateSnapshot",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:ModifyVolume",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumesModifications"
    ]
  }

  statement {
    effect = "Allow"

    resources = [
      "arn:${local.partition}:ec2:*:*:volume/*",
      "arn:${local.partition}:ec2:*:*:snapshot/*",
    ]

    actions = ["ec2:CreateTags"]

    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"

      values = [
        "CreateVolume",
        "CreateSnapshot",
      ]
    }
  }

  statement {
    effect = "Allow"

    resources = [
      "arn:${local.partition}:ec2:*:*:volume/*",
      "arn:${local.partition}:ec2:*:*:snapshot/*",
    ]

    actions = ["ec2:DeleteTags"]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:CreateVolume"]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/ebs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:CreateVolume"]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/CSIVolumeName"
      values   = ["*"]
    }
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:CreateVolume"]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/kubernetes.io/cluster/*"
      values   = ["owned"]
    }
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:DeleteVolume"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:DeleteVolume"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CSIVolumeName"
      values   = ["*"]
    }
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:DeleteVolume"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/kubernetes.io/cluster/*"
      values   = ["owned"]
    }
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:DeleteSnapshot"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CSIVolumeSnapshotName"
      values   = ["*"]
    }
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:DeleteSnapshot"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }

  statement {
    effect = "Allow"
    resources = [
      module.ebs_csi_kms_key.key_arn
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
      module.ebs_csi_kms_key.key_arn
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

module "ebs_csi_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.2.1"

  aws_iam_policy_document     = local.ebs_csi_iam_policy_document
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = "ebs-csi-controller-sa"
  service_account_namespace   = try(local.argocd_helm_apps_set["ebs-csi"]["namespace"], "")

  label_order = var.irsa_label_order
  context     = module.ebs_csi_label.context
}
