variable "eks_cluster_id" {
  type        = string
  description = "EKS cluster ID."
}

variable "irsa_label_order" {
  type        = list(string)
  default     = ["namespace", "tenant", "stage", "attributes"]
  description = <<-EOT
    The order in which the labels (ID elements) appear in the `id`.
    Defaults to ["namespace", "environment", "stage", "name", "attributes"].
    You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present.
    EOT
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

variable "argocd_additional_projects" {
  type = list(object(
    {
      name        = string
      description = optional(string, "Managed by Terraform")
    }
  ))
  default     = []
  description = "A list of additional ArgoCD projects to create."
}

variable "argocd_app_config" {
  type = object(
    {
      name         = optional(string)
      namespace    = optional(string, "argo")
      annotations  = optional(map(string))
      project      = optional(string)
      wait         = optional(bool, false)
      sync_options = optional(list(string), ["CreateNamespace=true", "ApplyOutOfSyncOnly=true"])

      helm = optional(
        object(
          {
            repository = optional(string, "https://rallyware.github.io/terraform-argocd-aws-eks-cluster-bootstrap")
            chart      = optional(string, "argocd-app-of-apps")
            version    = optional(string, "0.6.2")
          }
      ), {})

      timeouts = optional(
        object(
          {
            create = optional(string, "60m")
            update = optional(string, "60m")
            delete = optional(string, "60m")
          }
      ), {})

      retry = optional(
        object(
          {
            limit                = optional(number, 0)
            backoff_duration     = optional(string, "30s")
            backoff_max_duration = optional(string, "1m")
            backoff_factor       = optional(number, 2)
          }
      ), {})

      destination = optional(
        object(
          {
            name      = optional(string, "in-cluster")
            namespace = optional(string, "argo")
          }
      ), {})

      automated = optional(
        object(
          {
            prune       = optional(bool, true)
            self_heal   = optional(bool, true)
            allow_empty = optional(bool, true)
          }
      ), {})
    }
  )
  default     = {}
  description = "A parent app configuration. Required when `argocd_cluster_default_enabled` is `false`"
}

variable "argocd_apps" {
  type = list(object(
    {
      name            = string
      repository      = string
      version         = string
      cluster         = optional(string)
      project         = optional(string)
      namespace       = optional(string, "default")
      chart           = optional(string, "")
      path            = optional(string, "")
      override_values = optional(string, "")
      skip_crds       = optional(bool, false)
      value_files     = optional(list(string), [])
      max_history     = optional(number, 10)
      sync_wave       = optional(number, 50)
      annotations     = optional(map(string), {})
      sync_options    = optional(list(string), ["CreateNamespace=true", "ApplyOutOfSyncOnly=true"])
      omit_finalizer  = optional(bool, false)

      ignore_differences = optional(
        list(object(
          {
            group             = optional(string)
            kind              = optional(string)
            jqPathExpressions = optional(list(string))
            jsonPointers      = optional(list(string))
          }
      )), null)

      retry = optional(
        object(
          {
            limit                = optional(number, 0)
            backoff_duration     = optional(string, "30s")
            backoff_max_duration = optional(string, "1m")
            backoff_factor       = optional(number, 2)
          }
      ), {})

      automated = optional(
        object(
          {
            prune       = optional(bool, true)
            self_heal   = optional(bool, true)
            allow_empty = optional(bool, true)
          }
      ), {})

      managed_namespace_metadata = optional(
        object(
          {
            labels      = optional(map(string))
            annotations = optional(map(string))
          }
      ), null)

      create_default_iam_policy  = optional(bool, true)
      create_default_iam_role    = optional(bool, true)
      iam_policy_document        = optional(string, "{}")
      use_sts_regional_endpoints = optional(bool, true)
    }
  ))
  default = [
    {
      name       = "prometheus-operator-crds"
      repository = "https://prometheus-community.github.io/helm-charts"
      chart      = "prometheus-operator-crds"
      namespace  = "default"
      version    = "0.1.1"
      sync_wave  = -25
    },

    {
      name       = "aws-vpc-cni"
      namespace  = "kube-system"
      repository = "https://aws.github.io/eks-charts"
      chart      = "aws-vpc-cni"
      version    = "1.2.2"
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
      name       = "argo-ecr-auth"
      namespace  = "argo"
      repository = "https://sarmad-abualkaz.github.io/my-helm-charts"
      chart      = "argo-ecr-auth"
      version    = "0.1.5"
      sync_wave  = -9
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
      version    = "0.2.1"
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
      name       = "aws-lb-controller"
      namespace  = "kube-system"
      chart      = "aws-load-balancer-controller"
      repository = "https://aws.github.io/eks-charts"
      version    = "1.4.6"
      sync_wave  = -5
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
      version    = "2.16.0"
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
      name       = "keda"
      namespace  = "infra"
      chart      = "keda"
      repository = "https://kedacore.github.io/charts"
      version    = "2.13.0"
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
      name       = "linkerd-crds"
      namespace  = "linkerd"
      chart      = "linkerd-crds"
      repository = "https://helm.linkerd.io/stable"
      version    = "1.4.0"
      sync_wave  = -20
      ignore_differences = [
        {
          group = "apiextensions.k8s.io"
          kind  = "CustomResourceDefinition"
          jsonPointers = [
            "/spec/names"
          ]
        }
      ]
    },

    {
      name       = "linkerd-helpers"
      namespace  = "linkerd"
      repository = "https://sweetops.github.io/helm-charts"
      chart      = "linkerd-helpers"
      version    = "0.1.1"
      sync_wave  = 3
    },

    {
      name       = "linkerd"
      namespace  = "linkerd"
      chart      = "linkerd-control-plane"
      repository = "https://helm.linkerd.io/stable"
      version    = "1.9.3"
      sync_wave  = 4
    },

    {
      name       = "linkerd-smi"
      namespace  = "linkerd-smi"
      chart      = "linkerd-smi"
      repository = "https://linkerd.github.io/linkerd-smi"
      version    = "0.2.0"
    },

    {
      name       = "linkerd-viz"
      namespace  = "linkerd-viz"
      chart      = "linkerd-viz"
      repository = "https://helm.linkerd.io/stable"
      version    = "30.3.3"
    },

    {
      name       = "linkerd-jaeger"
      namespace  = "linkerd-jaeger"
      chart      = "linkerd-jaeger"
      repository = "https://helm.linkerd.io/stable"
      version    = "30.4.3"
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
      repository = "public.ecr.aws/karpenter"
      version    = "v0.22.1"
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
      chart      = "loki"
      version    = "3.6.0"
      ignore_differences = [
        {
          group             = "apps"
          kind              = "StatefulSet"
          jqPathExpressions = [".spec.persistentVolumeClaimRetentionPolicy"]
        }
      ]
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
      name       = "oauth2-proxy"
      namespace  = "infra"
      repository = "https://oauth2-proxy.github.io/manifests"
      chart      = "oauth2-proxy"
      version    = "4.2.0"
    },
    {
      name       = "efs-csi"
      namespace  = "csi-drivers"
      chart      = "aws-efs-csi-driver"
      repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
      version    = "2.4.1"
    },
  ]
}
