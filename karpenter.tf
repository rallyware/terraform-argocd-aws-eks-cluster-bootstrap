locals {
  karpenter_enabled                    = module.this.enabled && contains(local.argocd_helm_apps_enabled, "karpenter")
  karpenter_iam_role_enabled           = local.karpenter_enabled ? local.argocd_helm_apps_set["karpenter"]["create_default_iam_role"] : false
  karpenter_iam_policy_enabled         = local.karpenter_enabled ? local.argocd_helm_apps_set["karpenter"]["create_default_iam_policy"] : false
  karpenter_iam_policy_document        = local.karpenter_iam_policy_enabled ? one(data.aws_iam_policy_document.karpenter[*].json) : try(local.argocd_helm_apps_set["karpenter"]["iam_policy_document"], "{}")
  karpenter_use_sts_regional_endpoints = local.karpenter_enabled ? local.argocd_helm_apps_set["karpenter"]["use_sts_regional_endpoints"] : false

  karpenter_events = {
    health-event = {
      name        = "HealthEvent"
      description = "Karpenter interrupt - AWS health event"
      event_pattern = {
        source      = ["aws.health"]
        detail-type = ["AWS Health Event"]
      }
    }
    spot-interupt = {
      name        = "SpotInterrupt"
      description = "Karpenter interrupt - EC2 spot instance interruption warning"
      event_pattern = {
        source      = ["aws.ec2"]
        detail-type = ["EC2 Spot Instance Interruption Warning"]
      }
    }
    rebalance = {
      name        = "InstanceRebalance"
      description = "Karpenter interrupt - EC2 instance rebalance recommendation"
      event_pattern = {
        source      = ["aws.ec2"]
        detail-type = ["EC2 Instance Rebalance Recommendation"]
      }
    }
    state-change = {
      name        = "InstanceStateChange"
      description = "Karpenter interrupt - EC2 instance state-change notification"
      event_pattern = {
        source      = ["aws.ec2"]
        detail-type = ["EC2 Instance State-change Notification"]
      }
    }
  }
}

module "karpenter_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.karpenter_iam_role_enabled
  context = module.this.context
}

module "karpenter_sqs" {
  source  = "rallyware/sqs-queue/aws"
  version = "0.2.1"

  name    = "karpenter"
  context = module.karpenter_label.context

  prebuilt_policy = {
    enabled = true
    principals = {
      identifiers = [
        "events.${local.dns_suffix}",
        "sqs.${local.dns_suffix}",
      ]
    }
  }
}

data "aws_iam_policy_document" "karpenter" {
  count = local.karpenter_iam_role_enabled ? (local.karpenter_iam_policy_enabled ? 1 : 0) : 0

  statement {
    effect = "Allow"

    resources = [
      "*"
    ]

    actions = [
      "ssm:GetParameter",
      "ec2:DescribeImages",
      "ec2:RunInstances",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeAvailabilityZones",
      "ec2:CreateTags",
      "ec2:CreateLaunchTemplate",
      "ec2:CreateFleet",
      "ec2:DescribeSpotPriceHistory",
      "pricing:GetProducts",
      "ec2:TerminateInstances",
      "ec2:DeleteLaunchTemplate",
    ]
  }

  statement {
    actions   = ["iam:PassRole"]
    resources = [module.karpenter_instance_profile.arn]
  }

  statement {
    actions = [
      "sqs:DeleteMessage",
      "sqs:GetQueueUrl",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage",
    ]
    resources = [module.karpenter_sqs.arn]
  }
}

module "karpenter_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.2.0"

  aws_iam_policy_document     = local.karpenter_iam_policy_document
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = try(local.argocd_helm_apps_set["karpenter"]["name"], "")
  service_account_namespace   = try(local.argocd_helm_apps_set["karpenter"]["namespace"], "")

  label_order = var.irsa_label_order
  context     = module.karpenter_label.context
}

module "karpenter_instance_profile" {
  source  = "cloudposse/iam-role/aws"
  version = "0.18.0"

  policy_document_count    = 0
  instance_profile_enabled = "true"
  policy_description       = "Allow nodes to pull images, setup networking"
  role_description         = "Karpenter instance profile for nodes to pull images, setup networking"

  principals = {
    Service = ["ec2.amazonaws.com"]
  }

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  name       = "karpenter"
  attributes = concat(module.karpenter_label.attributes, ["ip"])
  context    = module.karpenter_label.context
}

module "karpenter_event_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  for_each = { for k, v in local.karpenter_events : k => v if local.karpenter_enabled }

  name       = "karpenter"
  attributes = concat(module.karpenter_label.attributes, [each.key])
  context    = module.karpenter_label.context
}

resource "aws_cloudwatch_event_rule" "karpenter" {
  for_each = { for k, v in local.karpenter_events : k => v if local.karpenter_enabled }

  name          = module.karpenter_event_label[each.key].id
  description   = each.value.description
  event_pattern = jsonencode(each.value.event_pattern)
  tags          = module.karpenter_event_label[each.key].tags
}

resource "aws_cloudwatch_event_target" "karpenter" {
  for_each = { for k, v in local.karpenter_events : k => v if local.karpenter_enabled }

  rule      = aws_cloudwatch_event_rule.karpenter[each.key].name
  target_id = "KarpenterInterruptionQueueTarget"
  arn       = module.karpenter_sqs.arn
}
