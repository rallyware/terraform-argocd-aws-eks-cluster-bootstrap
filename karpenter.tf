locals {
  karpenter_enabled = module.this.enabled && contains(local.argocd_helm_apps_enabled, "karpenter")
}

module "karpenter_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.karpenter_enabled
  name    = "karpenter"
  context = module.this.context
}

data "aws_iam_policy_document" "karpenter" {
  count = local.karpenter_enabled ? 1 : 0

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
      "iam:PassRole",
      "ec2:TerminateInstances",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeInstances",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeAvailabilityZones",
      "ssm:GetParameter"
    ]
  }
}

module "karpenter_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.1.1"

  aws_iam_policy_document     = one(data.aws_iam_policy_document.karpenter[*].json)
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = try(local.argocd_helm_apps_set["karpenter"]["name"], "")
  service_account_namespace   = try(local.argocd_helm_apps_set["karpenter"]["namespace"], "")

  context = module.karpenter_label.context
}
