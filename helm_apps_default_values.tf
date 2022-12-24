locals {
  argocd_helm_apps_enabled = local.enabled ? [for app in local.argocd_apps : app.name] : []
  argocd_helm_apps_set     = local.enabled ? { for app in local.argocd_apps : app.name => app if app.chart != null } : {}
  argocd_helm_apps_default_values = {
    argo-rollouts = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["argo-rollouts"]["name"], "")
    }

    argo-ecr-auth = {
      "fullnameOverride"     = try(local.argocd_helm_apps_set["argo-ecr-auth"]["name"], "")
      namespace              = try(local.argocd_helm_apps_set["argo-ecr-auth"]["namespace"], "")
      region                 = local.region
      account_id             = local.account_id
      sts_regional_endpoints = local.argo_ecr_auth_use_sts_regional_endpoints
      role_arn               = module.argo_ecr_auth_eks_iam_role.service_account_role_arn
      role_enabled           = local.argo_ecr_auth_iam_role_enabled
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

    linkerd-crds = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["linkerd-crds"]["name"], "")
    }

    linkerd-helpers = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["linkerd-helpers"]["name"], "")
      linkerd = {
        enabled = local.linkerd_enabled
      }
      linkerdViz = {
        enabled = local.linkerd_viz_enabled
      }
      linkerdJaeger = {
        enabled = local.linkerd_jaeger_enabled
      }
    }

    linkerd-smi = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["linkerd-smi"]["name"], "")
      "installNamespace" = false
      "namespace"        = try(local.argocd_helm_apps_set["linkerd-smi"]["namespace"], "")
    }

    linkerd = {
      "fullnameOverride"        = try(local.argocd_helm_apps_set["linkerd"]["name"], "")
      "installNamespace"        = false
      "identityTrustAnchorsPEM" = try(tls_self_signed_cert.linkerd["root.linkerd.cluster.local"].cert_pem, "")

      "identity" = {
        "issuer" = {
          "scheme" = "kubernetes.io/tls"
        }
      }

      "profileValidator" = {
        "externalSecret" = true
        "injectCaFrom"   = format("%s/linkerd-sp-validator", local.linkerd_namepsace)
      }

      "proxyInjector" = {
        "externalSecret" = true
        "injectCaFrom"   = format("%s/linkerd-proxy-injector", local.linkerd_namepsace)
      }

      "policyValidator" = {
        "externalSecret" = true
        "injectCaFrom"   = format("%s/linkerd-policy-validator", local.linkerd_namepsace)
      }
    }

    linkerd-viz = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["linkerd-viz"]["name"], "")
      "installNamespace" = false

      "tap" = {
        "externalSecret" = true
        "injectCaFrom"   = format("%s/linkerd-tap-injector", local.linkerd_viz_namepsace)
      }

      "tapInjector" = {
        "externalSecret" = true
        "injectCaFrom"   = format("%s/tap-k8s-tls", local.linkerd_viz_namepsace)
      }
    }

    linkerd-jaeger = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["linkerd-jaeger"]["name"], "")
      "installNamespace" = false

      "webhook" = {
        "externalSecret" = true
        "injectCaFrom"   = format("%s/jaeger-injector", local.linkerd_jaeger_namepsace)
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
        bucket_id              = module.tempo_s3_bucket.bucket_id
      }
    ))

    prometheus-yace-exporter = yamldecode(templatefile("${path.module}/helm-values/yace.yaml",
      {
        fullname_override      = try(local.argocd_helm_apps_set["prometheus-yace-exporter"]["name"], "")
        region                 = local.region
        sts_regional_endpoints = local.prometheus_yace_exporter_use_sts_regional_endpoints
        role_arn               = module.prometheus_yace_exporter_eks_iam_role.service_account_role_arn
        role_enabled           = local.prometheus_yace_exporter_iam_role_enabled
      }
    ))

    gha-controller = {
      "fullnameOverride"       = try(local.argocd_helm_apps_set["gha-controller"]["name"], "")
      "dockerRegistryMirror"   = "mirror.gcr.io"
      "githubAPICacheDuration" = "60s"
      "metrics" = {
        "serviceMonitor" = "enabled"
      }
      "resources" = {
        "limits" = {
          "cpu"    = "100m"
          "memory" = "128Mi"
        }
        "requests" = {
          "cpu"    = "100m"
          "memory" = "128Mi"
        }
      }
      "syncPeriod" = "30s"
    }

    oauth2-proxy = {
      "fullnameOverride" = try(local.argocd_helm_apps_set["oauth2-proxy"]["name"], "")
      "metrics" = {
        "enabled" = true
        "port"    = 44180
        "servicemonitor" = {
          "enabled"            = true
          "interval"           = "30s"
          "namespace"          = "monitoring"
          "prometheusInstance" = "default"
          "scrapeTimeout"      = "10s"
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
      "sessionStorage" = {
        "type" = "cookie"
      }
    }

    karpenter = yamldecode(templatefile("${path.module}/helm-values/karpenter.yaml",
      {
        fullname_override      = try(local.argocd_helm_apps_set["karpenter"]["name"], "")
        sts_regional_endpoints = local.karpenter_use_sts_regional_endpoints
        role_arn               = module.karpenter_eks_iam_role.service_account_role_arn
        role_enabled           = local.karpenter_iam_role_enabled
        cluster_name           = local.eks_cluster_id
        cluster_endpoint       = local.eks_cluster_endpoint
      }
    ))

    aws-lb-controller = yamldecode(templatefile("${path.module}/helm-values/aws-lb-controller.yaml",
      {
        fullname_override      = try(local.argocd_helm_apps_set["aws-lb-controller"]["name"], "")
        sts_regional_endpoints = local.aws_lb_controller_use_sts_regional_endpoints
        role_arn               = module.aws_lb_controller_eks_iam_role.service_account_role_arn
        role_enabled           = local.aws_lb_controller_enabled
        cluster_name           = local.eks_cluster_id
      }
    ))
  }
}

data "utils_deep_merge_yaml" "argocd_helm_apps" {
  for_each = local.argocd_helm_apps_set

  input = [
    yamlencode(try(local.argocd_helm_apps_default_values[each.key], {})),
    each.value.override_values != null ? each.value.override_values : ""
  ]
}
