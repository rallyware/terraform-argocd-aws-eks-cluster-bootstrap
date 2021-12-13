locals {
  destination_server  = one(argocd_cluster.default[*].server)
  destination_project = format("%s-bootstrap", local.eks_cluster_id)
}

resource "argocd_cluster" "default" {
  count = module.this.enabled ? 1 : 0

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
  count = module.this.enabled ? 1 : 0

  metadata {
    name      = local.destination_project
    namespace = var.argocd_namespace
    labels    = module.this.tags
  }

  spec {
    description  = format("Bootstrap %s", local.eks_cluster_id)
    source_repos = ["*"]

    destination {
      server    = local.destination_server
      namespace = "*"
    }

    orphaned_resources {
      warn = true
    }
  }
}


resource "argocd_project" "additional" {
  for_each = { for project in var.argocd_additional_projects :
    project.name => defaults(project,
      {
        description = "Managed by Terraform"
      }
    )
  }

  metadata {
    name      = each.value.name
    namespace = var.argocd_namespace
    labels    = module.this.tags
  }

  spec {
    description  = each.value.description
    source_repos = ["*"]

    destination {
      server    = local.destination_server
      namespace = "*"
    }

    orphaned_resources {
      warn = true
    }
  }
}
