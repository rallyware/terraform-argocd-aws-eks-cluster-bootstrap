locals {
  argocd_helm_apps_value = {
    clusterName = local.destination_name
    projectName = local.destination_project

    syncOptions = {
      CreateNamespace = true
    }

    syncPolicy = {
      prune      = true
      selfHeal   = true
      allowEmpty = true
    }

    annotations = var.argocd_app_annotations

    applications = [for app in local.argocd_helm_apps :
      {
        name           = module.helm_apps_label[app.name].id
        namespace      = app.namespace
        chart          = app.chart
        repoURL        = app.repository
        targetRevision = app.version
        syncWave       = app.sync_wave
        values         = data.utils_deep_merge_yaml.argocd_helm_apps[app.name].output
        releaseName    = app.name
      }
    ]
  }
}

module "helm_apps_label" {
  for_each = { for app in local.argocd_helm_apps : app.name => app }

  source  = "cloudposse/label/null"
  version = "0.25.0"

  name    = each.key
  context = module.this.context
}

resource "argocd_application" "helm_apps" {
  count = local.enabled ? 1 : 0

  metadata {
    name      = local.destination_project
    namespace = var.argocd_namespace
    labels    = module.this.tags
  }

  spec {
    project = local.destination_project

    source {
      repo_url        = var.app_of_apps_helm_chart["repository"]
      chart           = var.app_of_apps_helm_chart["chart"]
      target_revision = var.app_of_apps_helm_chart["version"]

      helm {
        values       = yamlencode(local.argocd_helm_apps_value)
        release_name = local.destination_project
      }
    }

    destination {
      name      = var.argocd_cluster_name
      namespace = var.argocd_namespace
    }

    sync_policy {
      automated = {
        prune       = true
        self_heal   = true
        allow_empty = true
      }

      sync_options = [
        "CreateNamespace=true"
      ]

      retry {
        limit = "2"

        backoff = {
          duration     = "30s"
          max_duration = "1m"
          factor       = "2"
        }
      }
    }
  }

  timeouts {
    create = "15m"
    update = "15m"
    delete = "5m"
  }

  depends_on = [
    argocd_application.crd_apps,
    argocd_project.default,
    argocd_project.additional
  ]
}
