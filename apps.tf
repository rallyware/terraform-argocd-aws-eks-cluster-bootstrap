locals {
  argocd_apps     = local.enabled ? var.argocd_apps : []
  argocd_app_name = can(var.argocd_app_config["name"]) ? var.argocd_app_config["name"] : local.argocd_destination_project

  argocd_helm_apps_value = {
    syncOptions = {
      CreateNamespace = true
    }

    syncPolicy = {
      prune      = true
      selfHeal   = true
      allowEmpty = true
    }

    applications = [for app in local.argocd_apps :
      {
        name              = module.apps_label[app.name].id
        namespace         = app.namespace
        chart             = app.chart
        repoURL           = app.repository
        path              = app.path
        targetRevision    = app.version
        syncWave          = app.sync_wave
        values            = data.utils_deep_merge_yaml.argocd_helm_apps[app.name].output
        releaseName       = app.name
        annotations       = app.annotations
        ignoreDifferences = app.ignore_differences != null ? app.ignore_differences : []
        clusterName       = app.cluster != null ? app.cluster : local.argocd_cluster_destination_name
        projectName       = app.project != null ? app.project : local.argocd_destination_project
        syncPolicy        = app.sync_policy
        syncOptions       = app.sync_options
        skipCrds          = app.skip_crds
        valueFiles        = app.value_files
      }
    ]
  }
}

module "apps_label" {
  for_each = { for app in local.argocd_apps : app.name => app }

  source  = "cloudposse/label/null"
  version = "0.25.0"

  name    = each.key
  context = module.this.context
}

resource "argocd_application" "apps" {
  count = local.enabled ? 1 : 0

  metadata {
    name        = local.argocd_app_name
    namespace   = var.argocd_namespace
    labels      = module.this.tags
    annotations = var.argocd_app_annotations
  }

  wait = var.argocd_app_config["wait"]

  spec {
    project = local.argocd_destination_project

    source {
      repo_url        = var.app_of_apps_helm_chart["repository"]
      chart           = var.app_of_apps_helm_chart["chart"]
      target_revision = var.app_of_apps_helm_chart["version"]

      helm {
        values       = yamlencode(local.argocd_helm_apps_value)
        release_name = local.argocd_destination_project
      }
    }

    destination {
      name      = var.argocd_app_config["cluster_name"]
      namespace = var.argocd_namespace
    }

    sync_policy {
      automated = {
        prune       = var.argocd_app_config["automated_prune"]
        self_heal   = var.argocd_app_config["automated_self_heal"]
        allow_empty = var.argocd_app_config["automated_allow_empty"]
      }

      sync_options = var.argocd_app_config["sync_options"]

      dynamic "retry" {
        for_each = var.argocd_app_config["retry_limit"] > 0 ? [1] : []

        content {
          limit = var.argocd_app_config["retry_limit"]

          backoff = {
            duration     = var.argocd_app_config["retry_backoff_duration"]
            max_duration = var.argocd_app_config["retry_backoff_max_duration"]
            factor       = var.argocd_app_config["retry_backoff_factor"]
          }
        }
      }
    }
  }

  timeouts {
    create = var.argocd_app_config["create"]
    update = var.argocd_app_config["update"]
    delete = var.argocd_app_config["delete"]
  }

  depends_on = [
    argocd_project.default,
    argocd_project.additional
  ]
}
