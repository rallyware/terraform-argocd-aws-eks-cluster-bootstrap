locals {
  argocd_apps      = local.enabled ? var.argocd_apps : []
  argocd_namespace = var.argocd_app_config["namespace"]
  argocd_app_name  = var.argocd_app_config["name"] != null ? var.argocd_app_config["name"] : local.argocd_destination_project

  argocd_helm_apps_value = {
    applications = [for app in local.argocd_apps :
      {
        name                     = module.apps_label[app.name].id
        namespace                = app.namespace
        chart                    = app.chart
        repoURL                  = app.repository
        path                     = app.path
        targetRevision           = app.version
        syncWave                 = app.sync_wave
        values                   = data.utils_deep_merge_yaml.argocd_helm_apps[app.name].output
        releaseName              = app.name
        annotations              = app.annotations
        ignoreDifferences        = app.ignore_differences != null ? app.ignore_differences : []
        clusterName              = app.cluster != null ? app.cluster : local.argocd_cluster_destination_name
        projectName              = app.project != null ? app.project : local.argocd_destination_project
        syncOptions              = app.sync_options
        skipCrds                 = app.skip_crds
        valueFiles               = app.value_files
        managedNamespaceMetadata = app.managed_namespace_metadata
        retry                    = app.retry
        revisionHistoryLimit     = app.max_history

        automated = {
          prune      = app.automated.prune
          selfHeal   = app.automated.self_heal
          allowEmpty = app.automated.allow_empty
        }
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
    namespace   = var.argocd_app_config["namespace"]
    labels      = module.this.tags
    annotations = var.argocd_app_config["annotations"]
  }

  wait = var.argocd_app_config["wait"]

  spec {
    project = local.argocd_destination_project

    source {
      repo_url        = var.argocd_app_config["helm"]["repository"]
      chart           = var.argocd_app_config["helm"]["chart"]
      target_revision = var.argocd_app_config["helm"]["version"]

      helm {
        values       = yamlencode(local.argocd_helm_apps_value)
        release_name = local.argocd_destination_project
      }
    }

    destination {
      name      = var.argocd_app_config["destination"]["name"]
      namespace = local.argocd_namespace
    }

    sync_policy {
      automated = {
        prune       = var.argocd_app_config["automated"]["prune"]
        self_heal   = var.argocd_app_config["automated"]["self_heal"]
        allow_empty = var.argocd_app_config["automated"]["allow_empty"]
      }

      sync_options = var.argocd_app_config["sync_options"]

      dynamic "retry" {
        for_each = var.argocd_app_config["retry"]["limit"] > 0 ? [1] : []

        content {
          limit = var.argocd_app_config["retry"]["limit"]

          backoff = {
            duration     = var.argocd_app_config["retry"]["backoff_duration"]
            max_duration = var.argocd_app_config["retry"]["backoff_max_duration"]
            factor       = var.argocd_app_config["retry"]["backoff_factor"]
          }
        }
      }
    }
  }

  timeouts {
    create = var.argocd_app_config["timeouts"]["create"]
    update = var.argocd_app_config["timeouts"]["update"]
    delete = var.argocd_app_config["timeouts"]["delete"]
  }

  depends_on = [
    argocd_project.default,
    argocd_project.additional
  ]
}
