locals {
  argocd_helm_apps_enabled = local.enabled ? [for app in local.argocd_apps : app.name] : []
  argocd_helm_apps_set     = local.enabled ? { for app in local.argocd_apps : app.name => app if length(app.chart) > 0 } : {}
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

    cluster-autoscaler = yamldecode(templatefile("${path.module}/helm-values/cluster-autoscaler.yaml",
      {
        fullname_override      = try(local.argocd_helm_apps_set["cluster-autoscaler"]["name"], "")
        region                 = local.region
        eks_cluster_id         = local.eks_cluster_id
        sts_regional_endpoints = local.cluster_autoscaler_use_sts_regional_endpoints
        role_arn               = module.cluster_autoscaler_eks_iam_role.service_account_role_arn
        role_enabled           = local.cluster_autoscaler_iam_role_enabled
      }
    ))

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
      "installNamespace" = false
      "namespace"        = "linkerd-smi"
    }

    linkerd = {
      "fullnameOverride"        = try(local.argocd_helm_apps_set["linkerd"]["name"], "")
      "installNamespace"        = false
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
      "installNamespace" = false

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
      "installNamespace" = false

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

    velero = yamldecode(templatefile("${path.module}/helm-values/velero.yaml",
      {
        fullname_override      = try(local.argocd_helm_apps_set["velero"]["name"], "")
        region                 = local.region
        sts_regional_endpoints = local.velero_use_sts_regional_endpoints
        role_arn               = module.velero_eks_iam_role.service_account_role_arn
        role_enabled           = local.velero_iam_role_enabled
        eks_cluster_id         = local.eks_cluster_id
        kms_key_id             = module.velero_kms_key.key_id
        bucket_id              = module.velero_s3_bucket.bucket_id
      }
    ))

    ebs-csi = yamldecode(templatefile("${path.module}/helm-values/ebs-csi.yaml",
      {
        fullname_override      = try(local.argocd_helm_apps_set["ebs-csi"]["name"], "")
        region                 = local.region
        sts_regional_endpoints = local.ebs_csi_use_sts_regional_endpoints
        role_arn               = module.ebs_csi_eks_iam_role.service_account_role_arn
        role_enabled           = local.ebs_csi_iam_role_enabled
        eks_cluster_id         = local.eks_cluster_id
        kms_key_id             = module.ebs_csi_kms_key.key_id
      }
    ))

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

    piggy-webhooks = yamldecode(templatefile("${path.module}/helm-values/piggy-webhooks.yaml",
      {
        fullname_override      = try(local.argocd_helm_apps_set["piggy-webhooks"]["name"], "")
        region                 = local.region
        sts_regional_endpoints = local.piggy_webhooks_use_sts_regional_endpoints
        role_arn               = module.piggy_webhooks_eks_iam_role.service_account_role_arn
        role_enabled           = local.piggy_webhooks_iam_role_enabled
      }
    ))

    loki = yamldecode(templatefile("${path.module}/helm-values/loki.yaml",
      {
        fullname_override      = try(local.argocd_helm_apps_set["loki"]["name"], "")
        region                 = local.region
        sts_regional_endpoints = local.loki_use_sts_regional_endpoints
        role_arn               = module.loki_eks_iam_role.service_account_role_arn
        compactor_role_arn     = module.loki_compactor_eks_iam_role.service_account_role_arn
        role_enabled           = local.loki_iam_role_enabled
        region                 = local.region
        bucket_id              = module.loki_s3_bucket.bucket_id
      }
    ))

    tempo = yamldecode(templatefile("${path.module}/helm-values/tempo.yaml",
      {
        fullname_override      = try(local.argocd_helm_apps_set["tempo"]["name"], "")
        region                 = local.region
        sts_regional_endpoints = local.tempo_use_sts_regional_endpoints
        role_arn               = module.tempo_eks_iam_role.service_account_role_arn
        role_enabled           = local.tempo_iam_role_enabled
        region                 = local.region
        bucket_id              = module.tempo_s3_bucket.bucket_id
      }
    ))
  }
}

data "utils_deep_merge_yaml" "argocd_helm_apps" {
  for_each = local.argocd_helm_apps_set

  input = [
    yamlencode(try(local.argocd_helm_apps_default_values[each.key], {})),
    each.value.override_values
  ]
}
