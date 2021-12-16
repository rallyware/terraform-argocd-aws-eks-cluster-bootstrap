locals {
  cluster_autoscaler_enabled = module.this.enabled && contains(local.argocd_helm_apps_enabled, "cluster-autoscaler")
}

module "cluster_autoscaler_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled     = local.cluster_autoscaler_enabled
  label_order = ["namespace", "tenant", "environment", "stage", "name", "attributes"]
  context     = module.this.context
}

data "aws_iam_policy_document" "cluster_autoscaler" {
  count = local.cluster_autoscaler_enabled ? 1 : 0

  statement {
    sid       = "ClusterAutoscaler"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]
  }
}

module "cluster_autoscaler_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.1.1"

  aws_iam_policy_document     = one(data.aws_iam_policy_document.cluster_autoscaler[*].json)
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = try(local.argocd_helm_apps_set["cluster-autoscaler"]["name"], "")
  service_account_namespace   = try(local.argocd_helm_apps_set["cluster-autoscaler"]["namespace"], "")

  context = module.cluster_autoscaler_label.context
}
