locals {
  enabled                     = module.this.enabled
  account_id                  = one(data.aws_caller_identity.default[*].account_id)
  eks_cluster_id              = one(data.aws_eks_cluster.default[*].id)
  eks_cluster_oidc_issuer_url = one(data.aws_eks_cluster.default[*].identity[0].oidc[0].issuer)
  eks_cluster_endpoint        = one(data.aws_eks_cluster.default[*].endpoint)
  dns_suffix                  = one(data.aws_partition.default[*].dns_suffix)
  partition                   = one(data.aws_partition.default[*].partition)
  region                      = one(data.aws_region.default[*].name)
}

data "aws_caller_identity" "default" {
  count = local.enabled ? 1 : 0
}

data "aws_partition" "default" {
  count = local.enabled ? 1 : 0
}

data "aws_eks_cluster" "default" {
  count = local.enabled ? 1 : 0

  name = var.eks_cluster_id
}

data "aws_region" "default" {
  count = local.enabled ? 1 : 0
}
