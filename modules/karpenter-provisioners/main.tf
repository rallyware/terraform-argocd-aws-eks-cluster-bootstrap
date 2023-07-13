locals {
  karpenter_provisioner_values = yamlencode({ provisioners = [for node in var.karpenter_node_pools :
    {
      name = node.name
      spec = {
        ttlSecondsAfterEmpty = node.ttl_seconds_after_empty
        labels               = node.kubernetes_labels
        annotations          = node.annotations

        consolidation = {
          enabled = node.ttl_seconds_after_empty == null ? true : false
        }

        requirements = node.requirements

        providerRef = {
          name = node.name
        }

        taints = node.taints

        startupTaints = node.startup_taints

        kubeletConfiguration = node.kubelet_configuration

        limits = node.limits

        ttlSecondsUntilExpired = node.ttl_seconds_until_expired

        ttlSecondsAfterEmpty = node.ttl_seconds_after_empty

        weight = node.weight
      }
    }
    ]

    nodetemplates = [for temp in var.node_templates :
      {
        name = temp.name
        spec = {
          amiFamily          = temp.ami_family
          tags               = module.karpenter_provisioner_label[node.name].tags
          detailedMonitoring = temp.detailed_monitoring
          instanceProfile    = temp.instance_profile
          userData           = temp.user_data

          subnetSelector = temp.subnet_selector
          #{
          #  aws-ids = join(",", local.private_subnet_ids) # TODO
          #}

          securityGroupSelector = temp.security_group_selector
          #{
          #  aws-ids = join(",", [data.aws_eks_cluster.saas.vpc_config[0].cluster_security_group_id]) # TODO
          #}

          amiSelector = temp.ami_selector
          #{
          #  aws-ids = join(",", [for arch in node.arch : data.aws_ami.karpenter_provisioner[arch].id])
          #}

          metadataOptions = temp.metadata_options

          blockDeviceMappings = temp.block_device_mappings
        }
      }
    ]
    }
  )
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
