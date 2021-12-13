locals {
  argocd_crd_apps_set = local.enabled ? { for app in var.argocd_crd_apps : app.name => app } : {}
}

resource "argocd_application" "crd_apps" {
  for_each = local.argocd_crd_apps_set

  metadata {
    name      = each.value.name
    namespace = local.destination_project
    labels    = module.this.tags

    annotations = merge(
      var.argocd_app_annotations,
      {
        "argocd.argoproj.io/sync-wave" = "-25"
      }
    )
  }

  wait = true

  spec {
    project = local.destination_project

    source {
      repo_url        = each.value.repository
      target_revision = each.value.version
      path            = each.value.path
    }

    destination {
      server    = local.destination_server
      namespace = "default"
    }

    sync_policy {
      automated = {
        prune       = true
        self_heal   = true
        allow_empty = true
      }

      sync_options = ["Validate=false"]

      retry {
        limit = "5"
        backoff = {
          duration     = "30s"
          max_duration = "1m"
          factor       = "2"
        }
      }
    }
  }

  depends_on = [
    argocd_project.default,
    argocd_project.additional
  ]
}
