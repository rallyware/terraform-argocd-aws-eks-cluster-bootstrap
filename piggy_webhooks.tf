locals {
  piggy_webhooks_enabled = module.this.enabled && contains(local.argocd_helm_apps_enabled, "piggy-webhooks")
}

data "aws_iam_policy_document" "piggy_webhook" {
  count = local.piggy_webhooks_enabled ? 1 : 0

  statement {
    sid       = "PiggySecretReadOnly"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:ListSecrets"
    ]
  }

  statement {
    sid       = "PiggyECRReadOnly"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer"
    ]
  }

  statement {
    sid       = "PiggyKMSDecrypt"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "kms:Decrypt"
    ]
  }
}

module "piggy_webhooks_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  name       = "piggy"
  attributes = ["webhook"]
  enabled    = local.piggy_webhooks_enabled
  context    = module.this.context
}

module "piggy_webhooks_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.1.1"

  aws_iam_policy_document     = one(data.aws_iam_policy_document.piggy_webhook[*].json)
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = try(local.argocd_helm_apps_set["piggy-webhook"]["name"], "")
  service_account_namespace   = try(local.argocd_helm_apps_set["piggy-webhook"]["namespace"], "")

  context = module.piggy_webhooks_label.context
}
