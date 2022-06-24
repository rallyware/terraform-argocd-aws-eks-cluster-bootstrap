locals {
  chartmuseum_enabled                    = module.this.enabled && contains(local.argocd_helm_apps_enabled, "chartmuseum")
  chartmuseum_iam_role_enabled           = local.chartmuseum_enabled ? local.argocd_helm_apps_set["chartmuseum"]["create_default_iam_role"] : false
  chartmuseum_iam_policy_enabled         = local.chartmuseum_enabled ? local.argocd_helm_apps_set["chartmuseum"]["create_default_iam_policy"] : false
  chartmuseum_iam_policy_document        = local.chartmuseum_iam_policy_enabled ? one(data.aws_iam_policy_document.chartmuseum[*].json) : try(local.argocd_helm_apps_set["chartmuseum"]["iam_policy_document"], "{}")
  chartmuseum_use_sts_regional_endpoints = local.chartmuseum_enabled ? local.argocd_helm_apps_set["chartmuseum"]["use_sts_regional_endpoints"] : false
}


module "chartmuseum_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.chartmuseum_iam_role_enabled
  context = module.this.context
}

module "chartmuseum_s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "2.0.2"

  acl                 = "private"
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  user_enabled        = false
  versioning_enabled  = false

  name    = "chartmuseum"
  context = module.chartmuseum_label.context
}

data "aws_iam_policy_document" "chartmuseum" {
  count = local.chartmuseum_enabled ? 1 : 0

  statement {
    sid    = "ChartmuseumAllowListObjects"
    effect = "Allow"

    resources = [
      module.chartmuseum_s3_bucket.bucket_arn
    ]

    actions = [
      "s3:ListBucket"
    ]
  }

  statement {
    sid    = "ChartmuseumAllowObjectsCRUD"
    effect = "Allow"

    resources = [
      format("%s/*", module.chartmuseum_s3_bucket.bucket_arn)
    ]

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]
  }
}

module "chartmuseum_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.1.2"

  aws_iam_policy_document     = local.chartmuseum_iam_policy_document
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = try(local.argocd_helm_apps_set["chartmuseum"]["name"], "")
  service_account_namespace   = try(local.argocd_helm_apps_set["chartmuseum"]["namespace"], "")

  context = module.chartmuseum_label.context
}
