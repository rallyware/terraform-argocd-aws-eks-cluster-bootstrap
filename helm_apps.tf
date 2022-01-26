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
        "nodeMetricsPort"    = 9081
        "typhaMetricsPort"   = 9091
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
      "identityTrustAnchorsPEM" = try(tls_self_signed_cert.linkerd["root.linkerd.cluster.local"].cert_pem, "")

      "identity" = {
        "issuer" = {
          "scheme" = "kubernetes.io/tls"
        }
        "certManager" = {
          "enabled" = true
          "tlsCrt"  = try(tls_self_signed_cert.linkerd["root.linkerd.cluster.local"].cert_pem, "")
          "tlsKey"  = try(tls_private_key.linkerd["root.linkerd.cluster.local"].private_key_pem, "")
        }
      }

      "profileValidator" = {
        "caBundle"       = try(tls_self_signed_cert.linkerd["webhook.linkerd.cluster.local"].cert_pem, "")
        "externalSecret" = true
      }

      "proxyInjector" = {
        "caBundle"       = try(tls_self_signed_cert.linkerd["webhook.linkerd.cluster.local"].cert_pem, "")
        "externalSecret" = true

        "certManager" = {
          "enabled" = true
          "tlsCrt"  = try(tls_self_signed_cert.linkerd["webhook.linkerd.cluster.local"].cert_pem, "")
          "tlsKey"  = try(tls_private_key.linkerd["webhook.linkerd.cluster.local"].private_key_pem, "")
        }
      }
      "monitoring" = {
        "enabled" = true
        "type"    = "prometheus-operator"
      }
    }

    linkerd-viz = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["linkerd-viz"]["name"], "")
      "installNamespace" = true

      "tap" = {
        "caBundle"       = try(tls_self_signed_cert.linkerd["webhook.linkerd.cluster.local"].cert_pem, "")
        "externalSecret" = true

        "certManager" = {
          "enabled" = true
          "tlsCrt"  = try(tls_self_signed_cert.linkerd["webhook.linkerd.cluster.local"].cert_pem, "")
          "tlsKey"  = try(tls_private_key.linkerd["webhook.linkerd.cluster.local"].private_key_pem, "")
        }
      }

      "tapInjector" = {
        "caBundle"       = try(tls_self_signed_cert.linkerd["webhook.linkerd.cluster.local"].cert_pem, "")
        "externalSecret" = true
      }
    }

    linkerd-jaeger = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["linkerd-jaeger"]["name"], "")
      "installNamespace" = true

      "webhook" = {
        "caBundle"       = try(tls_self_signed_cert.linkerd["webhook.linkerd.cluster.local"].cert_pem, "")
        "externalSecret" = true

        "certManager" = {
          "enabled" = true
          "tlsCrt"  = try(tls_self_signed_cert.linkerd["webhook.linkerd.cluster.local"].cert_pem, "")
          "tlsKey"  = try(tls_private_key.linkerd["webhook.linkerd.cluster.local"].private_key_pem, "")
        }
      }
    }

    velero = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["velero"]["name"], "")
      "serviceAccount" = {
        "annotations" = {
          "eks.amazonaws.com/role-arn" = module.velero_eks_iam_role.service_account_role_arn
        }
      }
      "configuration" = {
        "backupStorageLocation" = {
          "bucket"   = module.velero_s3_bucket.bucket_id
          "name"     = "default"
          "prefix"   = format("backups/%s", local.eks_cluster_id)
          "provider" = "aws"
          "region"   = local.region
        }
        "provider" = "aws"
        "volumeSnapshotLocation" = {
          "name"     = "default"
          "provider" = "aws"
          "region"   = local.region
          "kmsKeyId" = module.velero_kms_key.key_id
        }
      }
      "initContainers" = [
        {
          "image"           = "velero/velero-plugin-for-aws:v1.2.1"
          "imagePullPolicy" = "IfNotPresent"
          "name"            = "velero-plugin-for-aws"
          "volumeMounts" = [
            {
              "mountPath" = "/target"
              "name"      = "plugins"
            },
          ]
        },
      ]
      "metrics" = {
        "enabled"        = true
        "scrapeInterval" = "30s"
        "scrapeTimeout"  = "10s"
        "serviceMonitor" = {
          "enabled" = true
        }
      }
      "resources" = {
        "limits" = {
          "cpu"    = "1000m"
          "memory" = "512Mi"
        }
        "requests" = {
          "cpu"    = "500m"
          "memory" = "128Mi"
        }
      }
    }

    ebs-csi = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["ebs-csi"]["name"], "")
      "controller" = {
        "extraCreateMetadata" = true
        "k8sTagClusterId"     = local.eks_cluster_id
        "region"              = local.region
        "tolerateAllTaints"   = true
        "updateStrategy" = {
          "rollingUpdate" = {
            "maxSurge"       = 0
            "maxUnavailable" = 1
          }
          "type" = "RollingUpdate"
        }
        "serviceAccount" = {
          "annotations" = {
            "eks.amazonaws.com/role-arn" = module.ebs_csi_eks_iam_role.service_account_role_arn
          }
        }
      }
      "enableVolumeResizing" = true
      "enableVolumeSnapshot" = true
      "storageClasses" = [
        {
          "allowVolumeExpansion" = true
          "annotations" = {
            "storageclass.kubernetes.io/is-default-class" = "true"
          }
          "labels" = {
            "type" = "gp3"
          }
          "name" = "ebs-gp3"
          "parameters" = {
            "csi.storage.k8s.io/fstype" = "xfs"
            "encrypted"                 = "true"
            "kmsKeyId"                  = module.ebs_csi_kms_key.key_id
            "type"                      = "gp3"
          }
          "provisioner"       = "ebs.csi.aws.com"
          "reclaimPolicy"     = "Delete"
          "volumeBindingMode" = "WaitForFirstConsumer"
        },
      ]
    }

    aws-vpc-cni = {
      "fullnameOverride" = "aws-node"
      "init" = {
        "image" = {
          "region" = local.region
        }
      }
      "image" = {
        "region" = local.region
      }
      "eniConfig" = {
        "region" = local.region
      }
      "crd" = {
        "create" = false
      }
      "originalMatchLabels" = true
      "env" = {
        "ADDITIONAL_ENI_TAGS"                   = "{}"
        "AWS_VPC_CNI_NODE_PORT_SUPPORT"         = true
        "AWS_VPC_ENI_MTU"                       = "9001"
        "AWS_VPC_K8S_CNI_CONFIGURE_RPFILTER"    = false
        "AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG"    = false
        "AWS_VPC_K8S_CNI_EXTERNALSNAT"          = "false"
        "AWS_VPC_K8S_CNI_LOG_FILE"              = "/host/var/log/aws-routed-eni/ipamd.log"
        "AWS_VPC_K8S_CNI_LOGLEVEL"              = "DEBUG"
        "AWS_VPC_K8S_CNI_RANDOMIZESNAT"         = "prng"
        "AWS_VPC_K8S_CNI_VETHPREFIX"            = "eni"
        "AWS_VPC_K8S_PLUGIN_LOG_FILE"           = "/var/log/aws-routed-eni/plugin.log"
        "AWS_VPC_K8S_PLUGIN_LOG_LEVEL"          = "DEBUG"
        "DISABLE_INTROSPECTION"                 = false
        "DISABLE_METRICS"                       = false
        "ENABLE_POD_ENI"                        = false
        "ENABLE_PREFIX_DELEGATION"              = true
        "WARM_ENI_TARGET"                       = 1
        "WARM_PREFIX_TARGET"                    = 1
        "DISABLE_NETWORK_RESOURCE_PROVISIONING" = false
        "ENABLE_IPv4"                           = true
        "ENABLE_IPv6"                           = false
      }
    }

    piggy-webhook = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["piggy-webhook"]["name"], "")
      "mutate" = {
        "certificate" = {
          "certManager" = {
            "enabled" = true
          }
        }
      }
      "env" = {
        "AWS_REGION" = local.region
      }
      "serviceAccount" = {
        "annotations" = {
          "eks.amazonaws.com/role-arn" = module.piggy_webhook_eks_iam_role.service_account_role_arn
        }
      }
    }
  }
}

data "utils_deep_merge_yaml" "argocd_helm_apps" {
  for_each = local.argocd_helm_apps_set

  input = [
    yamlencode(try(local.argocd_helm_apps_default_values[each.key], {})),
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
      repo_url        = each.value.repository
      chart           = each.value.chart
      target_revision = each.value.version

      helm {
        values       = data.utils_deep_merge_yaml.argocd_helm_apps[each.key].output
        release_name = each.value.name
      }
    }

    destination {
      server    = local.destination_server
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
    argocd_application.crd_apps,
    argocd_project.default,
    argocd_project.additional
  ]
}
