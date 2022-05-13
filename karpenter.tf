locals {
  karpenter_enabled                    = module.this.enabled && contains(local.argocd_helm_apps_enabled, "karpenter")
  karpenter_iam_role_enabled           = local.karpenter_enabled ? local.argocd_helm_apps_set["karpenter"]["create_default_iam_role"] : false
  karpenter_iam_policy_enabled         = local.karpenter_enabled ? local.argocd_helm_apps_set["karpenter"]["create_default_iam_policy"] : false
  karpenter_iam_policy_document        = local.karpenter_iam_policy_enabled ? one(data.aws_iam_policy_document.karpenter[*].json) : try(local.argocd_helm_apps_set["karpenter"]["iam_policy_document"], "{}")
  karpenter_use_sts_regional_endpoints = local.karpenter_enabled ? local.argocd_helm_apps_set["karpenter"]["use_sts_regional_endpoints"] : false
}

module "karpenter_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.karpenter_enabled
  context = module.this.context
}

data "aws_iam_policy_document" "karpenter" {
  count = local.karpenter_iam_role_enabled ? (local.karpenter_iam_policy_enabled ? 1 : 0) : 0

  statement {
    effect = "Allow"

    resources = [
      "*"
    ]

    actions = [
      "ec2:CreateLaunchTemplate",
      "ec2:CreateFleet",
      "ec2:RunInstances",
      "ec2:CreateTags",
      "ec2:TerminateInstances",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeInstances",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeAvailabilityZones",
      "ssm:GetParameter",
      "iam:PassRole",
    ]
  }
}

module "karpenter_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.1.1"

  aws_iam_policy_document     = local.karpenter_iam_policy_document
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = try(local.argocd_helm_apps_set["karpenter"]["name"], "")
  service_account_namespace   = try(local.argocd_helm_apps_set["karpenter"]["namespace"], "")

  context = module.karpenter_label.context
}
