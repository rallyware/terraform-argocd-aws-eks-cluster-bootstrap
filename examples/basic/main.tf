provider "aws" {
  region = "eu-central-1"
}

provider "argocd" {
  server_addr = "argocd.example.com:443"
  username    = "username"
  password    = "password"
  grpc_web    = true
}

module "apps" {
  source = "../../"

  namespace = "rw"
  stage     = "test"

  eks_cluster_id                 = "test"
  argocd_cluster_default_enabled = false
  argocd_project_default_enabled = false

  argocd_app_config = {
    project = "test"
  }

  argocd_apps = [
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
      annotations = {
        "notifications.argoproj.io/subscribe.on-deployed.slack" = "argocd"
      }
    },

    {
      name       = "argo-rollouts"
      namespace  = "argo"
      chart      = "argo-rollouts"
      repository = "https://argoproj.github.io/argo-helm"
      version    = "2.0.1"
      ignore_differences = [
        {
          group               = "apps"
          kind                = "Deployment"
          jq_path_expressions = [".spec.replicas"]
        }
      ]
    },
  ]
}
