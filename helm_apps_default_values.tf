locals {
  argocd_helm_apps_enabled    = local.enabled ? [for app in local.argocd_apps : app.name] : []
  argocd_helm_apps_set        = local.enabled ? { for app in local.argocd_apps : app.name => app if app.chart != null } : {}
  prometheus_operator_enabled = local.enabled && contains(local.argocd_helm_apps_enabled, "prometheus-operator-crds")
  cert_manager_enabled        = local.enabled && contains(local.argocd_helm_apps_enabled, "cert-manager")

  argocd_helm_apps_default_values = {
    argo-rollouts = {
      fullnameOverride = try(local.argocd_helm_apps_set["argo-rollouts"]["name"], "")
      controller = {
        metrics = {
          enabled = local.prometheus_operator_enabled
          serviceMonitor = {
            enabled = local.prometheus_operator_enabled
          }
        }
      }
    }

    argo-ecr-auth = {
      fullnameOverride       = try(local.argocd_helm_apps_set["argo-ecr-auth"]["name"], "")
      namespace              = try(local.argocd_helm_apps_set["argo-ecr-auth"]["namespace"], "")
      region                 = local.region
      account_id             = local.account_id
      sts_regional_endpoints = local.argo_ecr_auth_use_sts_regional_endpoints
      role_arn               = module.argo_ecr_auth_eks_iam_role.service_account_role_arn
      role_enabled           = local.argo_ecr_auth_iam_role_enabled
    }

    aws-node-termination-handler = {
      fullnameOverride           = try(local.argocd_helm_apps_set["aws-node-termination-handler"]["name"], "")
      enablePrometheusServer     = false
      host_networking            = true
      nodeTerminationGracePeriod = 240
      podTerminationGracePeriod  = 60
      taintNode                  = true
      podMonitor = {
        create = false
      }
    }

    calico = {
      fullnameOverride = try(local.argocd_helm_apps_set["calico"]["name"], "")
      installation = {
        kubernetesProvider = "EKS"
        nodeMetricsPort    = 9081
        typhaMetricsPort   = 9091
      }
    }

    cert-manager = {
      fullnameOverride = try(local.argocd_helm_apps_set["cert-manager"]["name"], "")
      installCRDs      = true
      prometheus = {
        enabled = local.prometheus_operator_enabled
        servicemonitor = {
          enabled = local.prometheus_operator_enabled
        }
      }
    }

    cert-manager-issuers = {
      fullnameOverride = try(local.argocd_helm_apps_set["cert-manager-issuers"]["name"], "")
    }

    cluster-autoscaler = yamldecode(templatefile("${path.module}/helm-values/cluster-autoscaler.yaml",
      {
        fullname_override      = try(local.argocd_helm_apps_set["cluster-autoscaler"]["name"], "")
        region                 = local.region
        eks_cluster_id         = local.eks_cluster_id
        sts_regional_endpoints = local.cluster_autoscaler_use_sts_regional_endpoints
        role_arn               = module.cluster_autoscaler_eks_iam_role.service_account_role_arn
        role_enabled           = local.cluster_autoscaler_iam_role_enabled
        prometheus_enabled     = local.prometheus_operator_enabled
      }
    ))

    gatekeeper = {
      fullnameOverride = try(local.argocd_helm_apps_set["gatekeeper"]["name"], "")
    }

    ingress-nginx = {
      fullnameOverride = try(local.argocd_helm_apps_set["ingress-nginx"]["name"], "")
      controller = {
        metrics = {
          enabled = local.prometheus_operator_enabled
          serviceMonitor = {
            enabled = local.prometheus_operator_enabled
          }
        }
        certManager = {
          enabled = local.cert_manager_enabled
        }
      }
    }

    keda = {
      fullnameOverride = try(local.argocd_helm_apps_set["keda"]["name"], "")
      prometheus = {
        metricServer = {
          enabled = local.prometheus_operator_enabled
          podMonitor = {
            enabled = local.prometheus_operator_enabled
          }
        }
        operator = {
          enabled = local.prometheus_operator_enabled
          podMonitor = {
            enabled = local.prometheus_operator_enabled
          }
        }
      }
    }

    prometheus-blackbox-exporter = {
      fullnameOverride = try(local.argocd_helm_apps_set["prometheus-blackbox-exporter"]["name"], "")
    }

    victoria-metrics = {
      fullnameOverride = try(local.argocd_helm_apps_set["victoria-metrics"]["name"], "")
    }

    node-problem-detector = {
      fullnameOverride = try(local.argocd_helm_apps_set["node-problem-detector"]["name"], "")
      metrics = {
        enabled = local.prometheus_operator_enabled
        serviceMonitor = {
          enabled = local.prometheus_operator_enabled
        }
      }

      settings = {
        log_monitors = [
          "/config/kernel-monitor.json",
          "/config/docker-monitor.json",
          "/config/kernel-monitor-filelog.json",
          "/config/systemd-monitor-counter.json",
        ]
      }
    }

    node-local-dns = {
      fullnameOverride = try(local.argocd_helm_apps_set["node-local-dns"]["name"], "")
      serviceMonitor = {
        enabled = local.prometheus_operator_enabled
      }
    }

    linkerd-crds = {
      fullnameOverride = try(local.argocd_helm_apps_set["linkerd-crds"]["name"], "")
    }

    linkerd-helpers = {
      fullnameOverride = try(local.argocd_helm_apps_set["linkerd-helpers"]["name"], "")
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
      fullnameOverride = try(local.argocd_helm_apps_set["linkerd-smi"]["name"], "")
      installNamespace = false
      namespace        = try(local.argocd_helm_apps_set["linkerd-smi"]["namespace"], "")
    }

    linkerd = {
      fullnameOverride        = try(local.argocd_helm_apps_set["linkerd"]["name"], "")
      installNamespace        = false
      identityTrustAnchorsPEM = try(tls_self_signed_cert.linkerd["root.linkerd.cluster.local"].cert_pem, "")

      identity = {
        issuer = {
          scheme = "kubernetes.io/tls"
        }
      }

      profileValidator = {
        externalSecret = true
        injectCaFrom   = format("%s/linkerd-sp-validator", local.linkerd_namepsace)
      }

      proxyInjector = {
        externalSecret = true
        injectCaFrom   = format("%s/linkerd-proxy-injector", local.linkerd_namepsace)
      }

      policyValidator = {
        externalSecret = true
        injectCaFrom   = format("%s/linkerd-policy-validator", local.linkerd_namepsace)
      }
      podMonitor = {
        enabled = local.prometheus_operator_enabled
      }
    }

    linkerd-viz = {
      fullnameOverride = try(local.argocd_helm_apps_set["linkerd-viz"]["name"], "")
      installNamespace = false

      tap = {
        externalSecret = true
        injectCaFrom   = format("%s/linkerd-tap-injector", local.linkerd_viz_namepsace)
      }

      tapInjector = {
        externalSecret = true
        injectCaFrom   = format("%s/tap-k8s-tls", local.linkerd_viz_namepsace)
      }
    }

    linkerd-jaeger = {
      fullnameOverride = try(local.argocd_helm_apps_set["linkerd-jaeger"]["name"], "")
      installNamespace = false

      webhook = {
        externalSecret = true
        injectCaFrom   = format("%s/jaeger-injector", local.linkerd_jaeger_namepsace)
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
        prometheus_enabled     = local.prometheus_operator_enabled
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
        prometheus_enabled     = local.prometheus_operator_enabled
      }
    ))

    aws-vpc-cni = {
      fullnameOverride    = "aws-node"
      originalMatchLabels = true
      init = {
        image = {
          region = local.region
        }
      }
      image = {
        region = local.region
      }
      eniConfig = {
        region = local.region
      }
      env = {
        ENABLE_PREFIX_DELEGATION = true
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
        prometheus_enabled     = local.prometheus_operator_enabled
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
        prometheus_enabled     = local.prometheus_operator_enabled
      }
    ))

    external-dns = {
      fullnameOverride = try(local.argocd_helm_apps_set["external-dns"]["name"], "")
      txtSuffix        = local.eks_cluster_id
    }

    gha-controller = {
      fullnameOverride       = try(local.argocd_helm_apps_set["gha-controller"]["name"], "")
      dockerRegistryMirror   = "mirror.gcr.io"
      githubAPICacheDuration = "60s"
      metrics = {
        serviceMonitor = local.prometheus_operator_enabled
      }
      syncPeriod = "30s"
    }

    gha-runners = {
      fullnameOverride = try(local.argocd_helm_apps_set["gha-runners"]["name"], "")
    }

    argo-events = {
      fullnameOverride = try(local.argocd_helm_apps_set["argo-events"]["name"], "")
    }

    argo-workflows = {
      fullnameOverride = try(local.argocd_helm_apps_set["argo-workflows"]["name"], "")
    }

    oauth2-proxy = {
      fullnameOverride = try(local.argocd_helm_apps_set["oauth2-proxy"]["name"], "")
      metrics = {
        enabled = local.prometheus_operator_enabled
        servicemonitor = {
          enabled = local.prometheus_operator_enabled
        }
      }
      sessionStorage = {
        type = "cookie"
      }
    }

    chartmuseum = yamldecode(templatefile("${path.module}/helm-values/chartmuseum.yaml",
      {
        fullname_override      = try(local.argocd_helm_apps_set["chartmuseum"]["name"], "")
        region                 = local.region
        sts_regional_endpoints = local.chartmuseum_use_sts_regional_endpoints
        role_arn               = module.chartmuseum_eks_iam_role.service_account_role_arn
        role_enabled           = local.chartmuseum_iam_role_enabled
        bucket_id              = module.chartmuseum_s3_bucket.bucket_id
      }
    ))

    karpenter = yamldecode(templatefile("${path.module}/helm-values/karpenter.yaml",
      {
        fullname_override      = try(local.argocd_helm_apps_set["karpenter"]["name"], "")
        sts_regional_endpoints = local.karpenter_use_sts_regional_endpoints
        role_arn               = module.karpenter_eks_iam_role.service_account_role_arn
        role_enabled           = local.karpenter_iam_role_enabled
        cluster_name           = local.eks_cluster_id
        cluster_endpoint       = local.eks_cluster_endpoint
        instance_profile       = module.karpenter_instance_profile.name
        prometheus_enabled     = local.prometheus_operator_enabled
        sqs_queue_name         = module.karpenter_sqs.name
      }
    ))

    aws-lb-controller = yamldecode(templatefile("${path.module}/helm-values/aws-lb-controller.yaml",
      {
        fullname_override      = try(local.argocd_helm_apps_set["aws-lb-controller"]["name"], "")
        sts_regional_endpoints = local.aws_lb_controller_use_sts_regional_endpoints
        role_arn               = module.aws_lb_controller_eks_iam_role.service_account_role_arn
        role_enabled           = local.aws_lb_controller_enabled
        cluster_name           = local.eks_cluster_id
        prometheus_enabled     = local.prometheus_operator_enabled
        cert_manager_enabled   = local.cert_manager_enabled
      }
    ))

    aws-auth-controller = {
      fullnameOverride = try(local.argocd_helm_apps_set["argo-rollouts"]["name"], "")
    }

    iam-identity-mappings = {
      nodes = [
        {
          name = "karpenter"
          arn  = module.karpenter_instance_profile.arn
        }
      ]
    }
    efs-csi = yamldecode(templatefile("${path.module}/helm-values/efs-csi.yaml",
      {
        fullname_override      = try(local.argocd_helm_apps_set["efs-csi"]["name"], "")
        region                 = local.region
        sts_regional_endpoints = local.efs_csi_use_sts_regional_endpoints
        role_arn               = module.efs_csi_eks_iam_role.service_account_role_arn
        role_enabled           = local.efs_csi_iam_role_enabled
        eks_cluster_id         = local.eks_cluster_id
        kms_key_id             = module.efs_csi_kms_key.key_id
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
