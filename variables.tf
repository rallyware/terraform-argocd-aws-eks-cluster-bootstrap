variable "eks_cluster_id" {
  type        = string
  description = "EKS cluster ID."
}

variable "argocd_iam_role_arn" {
  type        = string
  default     = ""
  description = "IAM role ARN for ArgoCD to authenticate in EKS cluster."
}

variable "argocd_cluster_default_enabled" {
  type        = bool
  default     = true
  description = "Whether to create ArgoCD cluster resource. Requires: argocd_iam_role_arn"
}

variable "argocd_project_default_enabled" {
  type        = bool
  default     = true
  description = "Whether to create default ArgoCD project."
}

variable "argocd_namespace" {
  type        = string
  default     = "argo"
  description = "The Kubernetes namespace where ArgoCD installed to."
}

variable "argocd_additional_projects" {
  type = list(object(
    {
      name        = string
      description = optional(string)
    }
  ))
  default     = []
  description = "A list of additional ArgoCD projects to create."
}

variable "argocd_app_annotations" {
  type        = map(string)
  default     = {}
  description = "A map of annotations which we be applied to the parent app."
}

variable "app_of_apps_helm_chart" {
  type = object(
    {
      chart      = string
      repository = string
      version    = string
    }
  )

  default = {
    chart      = "argocd-app-of-apps"
    repository = "https://rallyware.github.io/terraform-argocd-aws-eks-cluster-bootstrap"
    version    = "0.5.0"
  }
}

variable "argocd_app_config" {
  type = object(
    {
      name                       = optional(string)
      project                    = optional(string)
      cluster_name               = optional(string)
      cluster_addr               = optional(string)
      wait                       = optional(bool)
      create                     = optional(string)
      update                     = optional(string)
      delete                     = optional(string)
      sync_options               = optional(list(string))
      automated_prune            = optional(bool)
      automated_self_heal        = optional(bool)
      automated_allow_empty      = optional(bool)
      retry_limit                = optional(number)
      retry_backoff_duration     = optional(string)
      retry_backoff_max_duration = optional(string)
      retry_backoff_factor       = optional(number)
    }
  )
  default = {
    cluster_name               = "in-cluster"
    create                     = "60m"
    update                     = "60m"
    delete                     = "60m"
    wait                       = false
    automated_prune            = true
    automated_self_heal        = true
    automated_allow_empty      = true
    retry_limit                = 2
    retry_backoff_duration     = "30s"
    retry_backoff_max_duration = "1m"
    retry_backoff_factor       = 2
  }
  description = "A parent app configuration. Required when `argocd_cluster_default_enabled` is `false`"
}

variable "argocd_app_default_params" {
  type = object(
    {
      max_history                = number
      override_values            = string
      sync_wave                  = number
      create_default_iam_policy  = bool
      create_default_iam_role    = bool
      iam_policy_document        = string
      use_sts_regional_endpoints = bool
      namespace                  = string
      chart                      = string
      path                       = string
      cluster                    = string
      project                    = string
      skip_crds                  = bool
    }
  )

  default = {
    max_history                = 10
    override_values            = ""
    sync_wave                  = 50
    create_default_iam_policy  = true
    create_default_iam_role    = true
    iam_policy_document        = "{}"
    use_sts_regional_endpoints = false
    namespace                  = "default"
    chart                      = ""
    path                       = ""
    cluster                    = ""
    project                    = ""
    skip_crds                  = false
  }
}

variable "argocd_apps" {
  type = list(object(
    {
      name            = string
      repository      = string
      version         = string
      cluster         = optional(string)
      project         = optional(string)
      namespace       = optional(string)
      chart           = optional(string)
      path            = optional(string)
      override_values = optional(string)
      skip_crds       = optional(bool)
      value_files     = optional(list(string))
      max_history     = optional(number)
      sync_wave       = optional(number)
      annotations     = optional(map(string))
      ignore_differences = optional(list(object(
        {
          group             = optional(string)
          kind              = string
          jqPathExpressions = optional(list(string))
          jsonPointers      = optional(list(string))
        }
      )))
      sync_policy                = optional(map(string))
      sync_options               = optional(map(string))
      create_default_iam_policy  = optional(bool)
      create_default_iam_role    = optional(bool)
      iam_policy_document        = optional(string)
      use_sts_regional_endpoints = optional(bool)
    }
  ))
  default = [
    {
      name       = "prometheus-operator-crds"
      repository = "https://github.com/prometheus-operator/prometheus-operator.git"
      namespace  = "default"
      path       = "example/prometheus-operator-crd/"
      version    = "v0.52.1"
      sync_wave  = -25
    },

    {
      name       = "aws-vpc-cni"
      namespace  = "kube-system"
      repository = "https://aws.github.io/eks-charts"
      chart      = "aws-vpc-cni"
      version    = "1.1.12"
      sync_wave  = -11
    },

    {
      name       = "calico"
      namespace  = "calico-system"
      repository = "https://docs.projectcalico.org/charts"
      chart      = "tigera-operator"
      version    = "v3.20.2"
      sync_wave  = -10
    },

    {
      name       = "argo-rollouts"
      namespace  = "argo"
      chart      = "argo-rollouts"
      repository = "https://argoproj.github.io/argo-helm"
      version    = "2.0.1"
    },

    {
      name       = "node-local-dns"
      namespace  = "kube-system"
      chart      = "node-local-dns"
      repository = "https://sweetops.github.io/helm-charts"
      version    = "0.2.0"
      sync_wave  = -9
    },

    {
      name       = "cert-manager"
      namespace  = "cert-manager"
      chart      = "cert-manager"
      repository = "https://charts.jetstack.io"
      version    = "1.5.0"
      sync_wave  = -7
    },

    {
      name       = "cert-manager-issuers"
      namespace  = "cert-manager"
      chart      = "cert-manager-issuers"
      repository = "https://charts.adfinis.com"
      version    = "0.2.2"
      sync_wave  = -6
    },

    {
      name       = "cluster-autoscaler"
      namespace  = "kube-system"
      chart      = "cluster-autoscaler"
      repository = "https://kubernetes.github.io/autoscaler"
      version    = "9.10.5"
      sync_wave  = -8
    },

    {
      name       = "ebs-csi"
      namespace  = "csi-drivers"
      chart      = "aws-ebs-csi-driver"
      repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
      version    = "2.1.0"
      sync_wave  = -5
    },

    {
      name       = "piggy-webhooks"
      namespace  = "infra"
      chart      = "piggy-webhooks"
      repository = "https://piggysec.com"
      version    = "0.2.9"
      sync_wave  = -4
    },

    {
      name       = "aws-node-termination-handler"
      namespace  = "node-termination-handler"
      chart      = "aws-node-termination-handler"
      repository = "https://aws.github.io/eks-charts"
      version    = "0.15.2"
    },

    {
      name       = "node-problem-detector"
      namespace  = "node-problem-detector"
      chart      = "node-problem-detector"
      repository = "https://charts.deliveryhero.io"
      version    = "2.0.5"
    },

    {
      name       = "ingress-nginx"
      namespace  = "infra"
      chart      = "ingress-nginx"
      repository = "https://kubernetes.github.io/ingress-nginx"
      version    = "4.0.1"
    },

    {
      name       = "velero"
      namespace  = "velero"
      chart      = "velero"
      repository = "https://vmware-tanzu.github.io/helm-charts"
      version    = "2.27.0"
    },

    {
      name       = "descheduler"
      namespace  = "kube-system"
      chart      = "descheduler"
      repository = "https://kubernetes-sigs.github.io/descheduler"
      version    = "0.21.0"
    },

    {
      name       = "keda"
      namespace  = "infra"
      chart      = "keda"
      repository = "https://kedacore.github.io/charts"
      version    = "2.4.0"
    },

    {
      name       = "falco"
      namespace  = "falco"
      chart      = "falco"
      repository = "https://falcosecurity.github.io/charts"
      version    = "1.15.7"
    },

    {
      name       = "falcosidekick"
      namespace  = "falco"
      chart      = "falcosidekick"
      repository = "https://falcosecurity.github.io/charts"
      version    = "0.3.17"
    },

    {
      name       = "gatekeeper"
      namespace  = "infra"
      chart      = "gatekeeper"
      repository = "https://open-policy-agent.github.io/gatekeeper/charts"
      version    = "3.6.0"
    },

    {
      name       = "victoria-metrics"
      namespace  = "monitoring"
      chart      = "victoria-metrics-k8s-stack"
      repository = "https://victoriametrics.github.io/helm-charts"
      version    = "0.5.3"
      sync_wave  = -3
    },

    {
      name       = "linkerd"
      namespace  = "linkerd"
      chart      = "linkerd2"
      repository = "https://sweetops.github.io/helm-charts"
      version    = "0.2.0"
    },

    {
      name       = "linkerd-smi"
      namespace  = "linkerd-smi"
      chart      = "linkerd-smi"
      repository = "https://linkerd.github.io/linkerd-smi"
      version    = "0.1.0"
    },

    {
      name       = "linkerd-viz"
      namespace  = "linkerd-viz"
      chart      = "linkerd-viz"
      repository = "https://sweetops.github.io/helm-charts"
      version    = "0.2.0"
    },

    {
      name       = "linkerd-jaeger"
      namespace  = "linkerd-jaeger"
      chart      = "linkerd-jaeger"
      repository = "https://sweetops.github.io/helm-charts"
      version    = "0.2.0"
    },

    {
      name       = "prometheus-blackbox-exporter"
      namespace  = "monitoring"
      chart      = "prometheus-blackbox-exporter"
      repository = "https://prometheus-community.github.io/helm-charts"
      version    = "5.0.3"
    },

    {
      name       = "karpenter"
      namespace  = "karpenter"
      chart      = "karpenter"
      repository = "https://charts.karpenter.sh"
      version    = "0.10.0"
      ignore_differences = [
        {
          kind = "Secret"
          jsonPointers = [
            "/data"
          ]
        }
      ]
    },

    {
      name       = "loki"
      namespace  = "logging"
      repository = "https://grafana.github.io/helm-charts"
      chart      = "loki-distributed"
      version    = "0.43.0"
    },

    {
      name       = "prometheus-yace-exporter"
      namespace  = "monitoring"
      repository = "https://mogaal.github.io/helm-charts"
      chart      = "prometheus-yace-exporter"
      version    = "0.5.0"
    },

    {
      name       = "tempo"
      namespace  = "tracing"
      repository = "https://grafana.github.io/helm-charts"
      chart      = "tempo-distributed"
      version    = "0.15.3"
    },

    {
      name       = "external-dns"
      namespace  = "infra"
      chart      = "external-dns"
      repository = "https://kubernetes-sigs.github.io/external-dns"
      version    = "1.9.0"
    },

    {
      name       = "gha-controller"
      namespace  = "cicd"
      repository = "https://actions-runner-controller.github.io/actions-runner-controller"
      chart      = "actions-runner-controller"
      version    = "0.15.1"
      sync_wave  = 20
    },

    {
      name       = "gha-runners"
      namespace  = "cicd"
      repository = "https://sweetops.github.io/helm-charts"
      chart      = "github-actions-runners"
      version    = "0.2.0"
      sync_wave  = 25
    },

    {
      name       = "argo-events"
      namespace  = "argo"
      repository = "https://argoproj.github.io/argo-helm"
      chart      = "argo-events"
      version    = "1.7.0"
    },

    {
      name       = "argo-workflows"
      namespace  = "argo"
      repository = "https://argoproj.github.io/argo-helm"
      chart      = "argo-workflows"
      version    = "0.5.2"
    },

    {
      name       = "argocd-notifications"
      namespace  = "argo"
      repository = "https://argoproj.github.io/argo-helm"
      chart      = "argocd-notifications"
      version    = "1.6.0"
    },

    {
      name       = "oauth2-proxy"
      namespace  = "infra"
      repository = "https://oauth2-proxy.github.io/manifests"
      chart      = "oauth2-proxy"
      version    = "4.2.0"
    },
  ]
}
