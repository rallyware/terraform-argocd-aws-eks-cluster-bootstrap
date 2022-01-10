variable "eks_cluster_id" {
  type        = string
  description = "EKS cluster ID."
}

variable "argocd_iam_role_arn" {
  type        = string
  description = "IAM role ARN for ArgoCD to authenticate in EKS cluster."
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
  description = "An unstructured key value map stored with the config map that may be used to store arbitrary metadata."
}

variable "argocd_helm_app_default_params" {
  type = object(
    {
      max_history     = number
      wait            = bool
      override_values = string
      sync_wave       = number
    }
  )

  default = {
    max_history     = 10
    wait            = false
    override_values = ""
    sync_wave       = 50
  }
}

variable "argocd_crd_apps" {
  type = list(object(
    {
      name       = string
      repository = string
      path       = string
      version    = string

    }
  ))

  default = [
    {
      name       = "prometheus-operator-crds"
      repository = "https://github.com/prometheus-operator/prometheus-operator.git"
      path       = "example/prometheus-operator-crd/"
      version    = "v0.52.1"
    }
  ]
}


variable "argocd_helm_apps" {
  type = list(object(
    {
      name            = string
      namespace       = string
      repository      = string
      chart           = string
      version         = string
      override_values = optional(string)
      max_history     = optional(number)
      wait            = optional(bool)
      sync_wave       = optional(number)
    }
  ))
  default = [
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
      sync_wave  = -4
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
      version    = "0.5.1"
    }
  ]
}
