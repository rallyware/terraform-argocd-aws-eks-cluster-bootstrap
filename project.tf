locals {
  argocd_cluster_default_enabled  = local.enabled && var.argocd_cluster_default_enabled
  argocd_project_default_enabled  = local.enabled && var.argocd_project_default_enabled
  argocd_destination_project      = local.enabled && var.argocd_app_config["project"] != null ? var.argocd_app_config["project"] : format("%s-bootstrap", local.eks_cluster_id)
  argocd_cluster_destination_name = local.argocd_cluster_default_enabled ? one(argocd_cluster.default[*].name) : "in-cluster"
}

resource "argocd_cluster" "default" {
  count = local.argocd_cluster_default_enabled ? 1 : 0

  server = local.eks_cluster_endpoint
  name   = local.eks_cluster_id

  config {
    aws_auth_config {
      cluster_name = var.eks_cluster_id
      role_arn     = var.argocd_iam_role_arn
    }

    tls_client_config {
      ca_data = base64decode(one(data.aws_eks_cluster.default[*].certificate_authority[0].data))
    }
  }
}

resource "argocd_project" "default" {
  count = local.argocd_project_default_enabled ? 1 : 0

  metadata {
    name      = local.argocd_destination_project
    namespace = local.argocd_namespace
    labels    = module.this.tags
  }

  spec {
    description  = format("Bootstrap %s", local.eks_cluster_id)
    source_repos = ["*"]

    destination {
      name      = local.argocd_cluster_destination_name
      namespace = "*"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = local.argocd_namespace
    }

    namespace_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    orphaned_resources {
      warn = true
    }
  }
}


resource "argocd_project" "additional" {
  for_each = { for project in var.argocd_additional_projects :
    project.name => project
  }

  metadata {
    name      = each.value.name
    namespace = local.argocd_namespace
    labels    = module.this.tags
  }

  spec {
    description  = each.value.description
    source_repos = ["*"]

    destination {
      name      = local.argocd_cluster_destination_name
      namespace = "*"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = local.argocd_namespace
    }

    namespace_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    orphaned_resources {
      warn = true
    }
  }
}
