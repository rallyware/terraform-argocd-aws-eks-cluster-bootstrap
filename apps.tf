locals {
  argocd_apps     = local.enabled ? [for app in var.argocd_apps : defaults(app, var.argocd_app_default_params)] : []
  argocd_app_name = length(local.argocd_app_config["name"]) > 0 ? local.argocd_app_config["name"] : local.argocd_destination_project

  argocd_app_config = defaults(var.argocd_app_config,
    {
      name         = ""
      project      = ""
      cluster_name = "in-cluster"
      cluster_addr = "https://kubernetes.default.svc"
      wait         = false
      create       = "60m"
      update       = "60m"
      delete       = "60m"
    }
  )

  argocd_helm_apps_value = {
    syncOptions = {
      CreateNamespace = true
    }

    syncPolicy = {
      prune      = true
      selfHeal   = true
      allowEmpty = true
    }

    annotations = var.argocd_app_annotations

    applications = [for app in local.argocd_apps :
      {
        name              = module.apps_label[app.name].id
        namespace         = app.namespace
        chart             = app.chart
        repoURL           = app.repository
        path              = app.path
        targetRevision    = app.version
        syncWave          = app.sync_wave
        values            = try(data.utils_deep_merge_yaml.argocd_helm_apps[app.name].output, "")
        releaseName       = app.name
        annotations       = app.annotations
        ignoreDifferences = app.ignore_differences
        clusterName       = length(app.cluster) > 0 ? app.cluster : local.argocd_cluster_destination_name
        projectName       = length(app.project) > 0 ? app.project : local.argocd_destination_project
        syncPolicy        = app.sync_policy
        syncOptions       = app.sync_options
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
    name      = local.argocd_app_name
    namespace = var.argocd_namespace
    labels    = module.this.tags
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
      name      = local.argocd_app_config["cluster_name"]
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
    create = local.argocd_app_config["create"]
    update = local.argocd_app_config["update"]
    delete = local.argocd_app_config["delete"]
  }

  depends_on = [
    argocd_project.default,
    argocd_project.additional
  ]
}
