locals {
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
          amiFamily          = "AL2"
          tags               = module.karpenter_provisioner_label[node.name].tags
          detailedMonitoring = true

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

data "aws_ami" "karpenter_provisioner" {
  for_each    = toset(["arm64", "amd64"])
  most_recent = true

  filter {
    name   = "name"
    values = ["eks-${each.value}-cluster-${var.kubernetes_version}-${var.karpenter_ami_version}"]
  }
}

module "karpenter_provisioner_label" {
  for_each = { for node in var.karpenter_node_pools : node.name => node }

  source  = "cloudposse/label/null"
  version = "0.25.0"

  name       = "karpenter"
  attributes = [each.value.name]
  context    = var.context
  tags       = each.value.kubernetes_labels
}
