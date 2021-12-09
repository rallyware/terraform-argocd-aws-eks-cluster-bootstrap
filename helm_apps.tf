locals {
  argocd_helm_apps         = local.enabled ? [for app in var.argocd_helm_apps : defaults(app, var.argocd_helm_app_default_params)] : []
  argocd_helm_apps_enabled = local.enabled ? [for app in local.argocd_helm_apps : app.name] : []
  argocd_helm_apps_set     = local.enabled ? { for app in local.argocd_helm_apps : app.name => app } : {}
  argocd_helm_apps_default_values = {
    argo-rollouts = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["argo-rollouts"]["name"], "")
    }

    aws-node-termination-handler = {
      "fullnameOverride"           = try(local.argocd_helm_apps_set["aws-node-termination-handler"]["name"], "")
      "enablePrometheusServer"     = false
      "host_networking"            = true
      "nodeTerminationGracePeriod" = 240
      "podMonitor" = {
        "create" = false
      }
      "podTerminationGracePeriod" = 60
      "taintNode"                 = true
    }

    calico = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["calico"]["name"], "")
      "installation" = {
        "kubernetesProvider" = "EKS"
      }
    }

    cert-manager = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["cert-manager"]["name"], "")
      "installCRDs"      = true
      "prometheus" = {
        "enabled" = true
        "servicemonitor" = {
          "enabled" = true
        }
      }
    }

    cert-manager-issuers = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["cert-manager-issuers"]["name"], "")
    }

    cluster-autoscaler = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["cluster-autoscaler"]["name"], "")
      "cloudProvider"    = "aws"
      "awsRegion"        = local.region
      "autoDiscovery" = {
        "clusterName" = local.eks_cluster_id
      }
      "rbac" = {
        "serviceAccount" = {
          "annotations" = {
            "eks.amazonaws.com/role-arn" = module.cluster_autoscaler_eks_iam_role.service_account_role_arn
          }
        }
      }
    }

    descheduler = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["descheduler"]["name"], "")
    }

    gatekeeper = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["gatekeeper"]["name"], "")
    }

    ingress-nginx = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["ingress-nginx"]["name"], "")
    }

    keda = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["keda"]["name"], "")
    }

    prometheus-blackbox-exporter = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["prometheus-blackbox-exporter"]["name"], "")
    }

    victoria-metrics = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["victoria-metrics"]["name"], "")
    }

    node-problem-detector = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["node-problem-detector"]["name"], "")
      "metrics" = {
        "enabled" = true
        "serviceMonitor" = {
          "enabled" = true
        }
      }
      "resources" = {
        "limits" = {
          "cpu"    = "100m"
          "memory" = "100Mi"
        }
        "requests" = {
          "cpu"    = "50m"
          "memory" = "50Mi"
        }
      }
      "settings" = {
        "log_monitors" = [
          "/config/kernel-monitor.json",
          "/config/docker-monitor.json",
          "/config/kernel-monitor-filelog.json",
          "/config/systemd-monitor-counter.json",
        ]
      }
    }

    node-local-dns = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["node-local-dns"]["name"], "")
      "config" = {
        "localDnsIp" = "169.254.20.10"
        "kubeDnsIp"  = "172.20.0.10"
        "zones" = [
          {
            "plugins" = {
              "cache" = {
                "denial" = {
                  "size" = 0
                  "ttl"  = 1
                }
                "parameters"  = 30
                "prefetch"    = {}
                "serve_stale" = false
                "success" = {
                  "size" = 9984
                  "ttl"  = 30
                }
              }
              "debug"  = false
              "errors" = true
              "forward" = {
                "expire"       = ""
                "force_tcp"    = false
                "health_check" = ""
                "max_fails"    = ""
                "parameters"   = "__PILLAR__CLUSTER__DNS__"
                "policy"       = ""
                "prefer_udp"   = false
              }
              "health" = {
                "port" = 8080
              }
              "log" = {
                "classes" = "all"
                "format"  = "combined"
              }
              "prometheus" = true
              "reload"     = true
            }
            "zone" = "cluster.local:53"
          },
          {
            "plugins" = {
              "cache" = {
                "parameters" = 30
              }
              "debug"  = false
              "errors" = true
              "forward" = {
                "force_tcp"  = false
                "parameters" = "__PILLAR__CLUSTER__DNS__"
              }
              "health" = {
                "port" = 8080
              }
              "log" = {
                "classes" = "all"
                "format"  = "combined"
              }
              "prometheus" = true
              "reload"     = true
            }
            "zone" = "ip6.arpa:53"
          },
          {
            "plugins" = {
              "cache" = {
                "parameters" = 30
              }
              "debug"  = false
              "errors" = true
              "forward" = {
                "force_tcp"  = false
                "parameters" = "__PILLAR__CLUSTER__DNS__"
              }
              "health" = {
                "port" = 8080
              }
              "log" = {
                "classes" = "all"
                "format"  = "combined"
              }
              "prometheus" = true
              "reload"     = true
            }
            "zone" = "in-addr.arpa:53"
          },
          {
            "plugins" = {
              "cache" = {
                "parameters"  = 30
                "serve_stale" = false
              }
              "debug"  = false
              "errors" = true
              "forward" = {
                "expire"       = ""
                "force_tcp"    = false
                "health_check" = ""
                "max_fails"    = ""
                "parameters"   = "__PILLAR__UPSTREAM__SERVERS__"
                "policy"       = ""
                "prefer_udp"   = false
              }
              "health" = {
                "port" = 8080
              }
              "log" = {
                "classes" = "all"
                "format"  = "combined"
              }
              "prometheus" = true
              "reload"     = true
            }
            "zone" = ".:53"
          },
        ]
      }
      "image" = {
        "args" = {
          "setupIptables" = true
          "skipTeardown"  = false
        }
      }
      "serviceMonitor" = {
        "enabled" = true
      }
    }

    linkerd-smi = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["linkerd-smi"]["name"], "")
      "installNamespace" = true
      "namespace"        = "linkerd-smi"
    }

    linkerd = {
      "fullnameOverride"        = try(local.argocd_helm_apps_set["linkerd"]["name"], "")
      "installNamespace"        = true
      "identityTrustAnchorsPEM" = tls_self_signed_cert.linkerd["root.linkerd.cluster.local"].cert_pem

      "certManager" = {
        "enabled" = true
        "tlsCrt"  = tls_self_signed_cert.linkerd["root.linkerd.cluster.local"].cert_pem
        "tlsKey"  = tls_private_key.linkerd["root.linkerd.cluster.local"].private_key_pem
      }

      "identity" = {
        "issuer" = {
          "scheme" = "kubernetes.io/tls"
        }
      }

      "profileValidator" = {
        "caBundle"       = tls_self_signed_cert.linkerd["webhook.linkerd.cluster.local"].cert_pem
        "externalSecret" = true
      }

      "proxyInjector" = {
        "caBundle"       = tls_self_signed_cert.linkerd["webhook.linkerd.cluster.local"].cert_pem
        "externalSecret" = true

        "certManager" = {
          "enabled" = true
          "tlsCrt"  = tls_self_signed_cert.linkerd["webhook.linkerd.cluster.local"].cert_pem
          "tlsKey"  = tls_private_key.linkerd["webhook.linkerd.cluster.local"].private_key_pem
        }
      }
      "monitoring" = {
        "enabled" = true
        "type"    = "victoria-metrics"
      }
    }

    linkerd-viz = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["linkerd-viz"]["name"], "")
      "installNamespace" = true

      "tap" = {
        "caBundle"       = tls_self_signed_cert.linkerd["webhook.linkerd.cluster.local"].cert_pem
        "externalSecret" = true

        "certManager" = {
          "enabled" = true
          "tlsCrt"  = tls_self_signed_cert.linkerd["webhook.linkerd.cluster.local"].cert_pem
          "tlsKey"  = tls_private_key.linkerd["webhook.linkerd.cluster.local"].private_key_pem
        }
      }

      "tapInjector" = {
        "caBundle"       = tls_self_signed_cert.linkerd["webhook.linkerd.cluster.local"].cert_pem
        "externalSecret" = true
      }
    }

    linkerd-jaeger = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["linkerd-jaeger"]["name"], "")
      "installNamespace" = true

      "webhook" = {
        "caBundle"       = tls_self_signed_cert.linkerd["webhook.linkerd.cluster.local"].cert_pem
        "externalSecret" = true

        "certManager" = {
          "enabled" = true
          "tlsCrt"  = tls_self_signed_cert.linkerd["webhook.linkerd.cluster.local"].cert_pem
          "tlsKey"  = tls_private_key.linkerd["webhook.linkerd.cluster.local"].private_key_pem
        }
      }
    }
  }
}

data "utils_deep_merge_yaml" "argocd_helm_apps" {
  for_each = local.argocd_helm_apps_set

  input = [
    yamlencode(try(local.argocd_helm_apps_default_values[each.key], "")),
    each.value.override_values
  ]
}

resource "argocd_application" "helm_apps" {
  for_each = local.argocd_helm_apps_set

  metadata {
    name        = each.value.name
    namespace   = var.argocd_namespace
    labels      = module.this.tags
    annotations = merge(var.argocd_app_annotations, { "argocd.argoproj.io/sync-wave" = each.value.sync_wave })
  }

  spec {
    project = local.destination_project

    source {
      repo_url        = each.value.repo_url
      chart           = each.value.chart
      target_revision = each.value.target_revision

      helm {
        values       = data.utils_deep_merge_yaml.argocd_helm_apps[each.key].output
        release_name = each.value.chart
      }
    }

    destination {
      name      = local.destination_server
      namespace = each.value.namespace
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
    argocd_application.crd_apps
  ]
}