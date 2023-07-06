locals {
  karpenter_provisioner_enabled                    = module.this.enabled && contains(local.argocd_helm_apps_enabled, "karpenter_provisioner")
  karpenter_provisioner_iam_role_enabled           = local.karpenter_provisioner_enabled ? local.argocd_helm_apps_set["karpenter_provisioner"]["create_default_iam_role"] : false
  karpenter_provisioner_iam_policy_enabled         = local.karpenter_provisioner_enabled ? local.argocd_helm_apps_set["karpenter_provisioner"]["create_default_iam_policy"] : false
  karpenter_provisioner_iam_policy_document        = local.karpenter_provisioner_iam_policy_enabled ? one(data.aws_iam_policy_document.karpenter_provisioner[*].json) : try(local.argocd_helm_apps_set["karpenter_provisioner"]["iam_policy_document"], "{}")
  karpenter_provisioner_use_sts_regional_endpoints = local.karpenter_provisioner_enabled ? local.argocd_helm_apps_set["karpenter_provisioner"]["use_sts_regional_endpoints"] : false

  karpenter_provisioner_values = yamlencode({ provisioners = [for node in var.karpenter_node_pools :
    {
      name = node.name
      spec = {
        ttlSecondsAfterEmpty = 300
        labels               = node.kubernetes_labels

        consolidation = {
          enabled = false
        }

        requirements = [
          {
            key      = "karpenter.sh/capacity-type"
            operator = "In"
            values   = ["on-demand", "spot"]
          },
          {
            key      = "kubernetes.io/arch"
            operator = "In"
            values   = ["arm64", "amd64"]
          },
          {
            key      = "node.kubernetes.io/instance-type"
            operator = "In"
            values   = sort(node.instance_types)
          },
          {
            key      = "topology.kubernetes.io/zone"
            operator = "In"
            values   = local.vpc_azs
          },
          {
            key      = "kubernetes.io/os"
            operator = "In"
            values   = ["linux"]
          }
        ]

        providerRef = {
          name = node.name
        }

        kubeletConfiguration = {
          maxPods = 110

          kubeReserved = {
            cpu    = "100m"
            memory = "200Mi"
          }

          evictionHard = {
            "memory.available" = "2%"
          }

          evictionSoft = {
            "memory.available" = "5%"
          }

          evictionSoftGracePeriod = {
            "memory.available" = "5m0s"
          }

          evictionMaxPodGracePeriod = 600
        }
      }
    }
    ]

    nodetemplates = [for node in var.karpenter_node_pools :
      {
        name = node.name
        spec = {
          amiFamily = "AL2"
          tags      = module.karpenter_provisioner_label[node.name].tags

          subnetSelector = {
            aws-ids = join(",", local.private_subnet_ids)
          }

          securityGroupSelector = {
            aws-ids = join(",", [data.aws_eks_cluster.saas.vpc_config[0].cluster_security_group_id])
          }

          amiSelector = {
            aws-ids = join(",", [for arch in ["arm64", "amd64"] : data.aws_ami.karpenter_provisioner[arch].id])
          }

          metadataOptions = {
            httpEndpoint            = "enabled"
            httpPutResponseHopLimit = 2
            httpTokens              = "required"
          }

          blockDeviceMappings = [
            {
              deviceName = "/dev/xvda"
              ebs = {
                volumeType          = "gp3"
                volumeSize          = "35Gi"
                deleteOnTermination = true
                encrypted           = true
              }
            }
          ]
        }
      }
    ]
    }
  )
  
}

module "karpenter_provisioner_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.karpenter_provisioner_iam_role_enabled
  context = module.this.context
}
