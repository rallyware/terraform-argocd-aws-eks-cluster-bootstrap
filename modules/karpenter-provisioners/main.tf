locals {
  karpenter_provisioner_values = yamlencode({ provisioners = [for node in var.karpenter_node_pools :
    {
      name = node.name
      spec = {
        ttlSecondsAfterEmpty = node.consolidation == true ? null : node.ttl_seconds_after_empty
        labels               = node.kubernetes_labels
        annotations          = node.annotations

        consolidation = {
          enabled = node.consolidation
        }

        requirements = node.requirements

        providerRef = {
          name = node.name
        }

        taints = node.taints

        startupTaints = node.startup_taints

        kubeletConfiguration = {
          clusterDNS       = node.kubelet_configuration.cluster_dns
          containerRuntime = node.kubelet_configuration.container_runtime
          systemReserved = {
            cpu               = node.kubelet_configuration.cpu_system_reserved
            memory            = node.kubelet_configuration.memory_system_reserved
            ephemeral-storage = node.kubelet_configuration.ephemeral_storage_system_reserved
          }
          kubeReserved = {
            cpu               = node.kubelet_configuration.cpu_kube_reserved
            memory            = node.kubelet_configuration.memory_kube_reserved
            ephemeral-storage = node.kubelet_configuration.ephemeral_storage_kube_reserved
          }
          evictionHard = {
            "memory.available"  = node.kubelet_configuration.memory_eviction_hard
            "nodefs.available"  = node.kubelet_configuration.nodefs_eviction_hard
            "nodefs.inodesFree" = node.kubelet_configuration.inodes_free_eviction_hard
          }
          evictionSoft = {
            "memory.available"  = node.kubelet_configuration.memory_eviction_soft
            "nodefs.available"  = node.kubelet_configuration.nodefs_eviction_soft
            "nodefs.inodesFree" = node.kubelet_configuration.inodes_free_eviction_soft
          }
          evictionSoftGracePeriod = {
            "memory.available"  = node.kubelet_configuration.memory_eviction_soft_grace_period
            "nodefs.available"  = node.kubelet_configuration.nodefs_eviction_soft_grace_period
            "nodefs.inodesFree" = node.kubelet_configuration.inodes_free_eviction_soft_grace_period
          }
          evictionMaxPodGracePeriod   = node.kubelet_configuration.eviction_max_pod_grace_period
          imageGCHighThresholdPercent = node.kubelet_configuration.image_gc_high_threshold_percent
          imageGCLowThresholdPercent  = node.kubelet_configuration.image_gc_low_threshold_percent
          cpuCFSQuota                 = node.kubelet_configuration.cpu_cfs_quota
          podsPerCore                 = node.kubelet_configuration.pods_per_core
          maxPods                     = node.kubelet_configuration.max_pods
        }

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
          tags               = module.karpenter_provisioner_label[temp.name].tags
          detailedMonitoring = temp.detailed_monitoring
          instanceProfile    = temp.instance_profile
          userData           = temp.user_data

          subnetSelector = var.subnet_selector
          #{
          #  aws-ids = join(",", local.private_subnet_ids) # TODO
          #}

          securityGroupSelector = var.security_group_selector
          #{
          #  aws-ids = join(",", [data.aws_eks_cluster.saas.vpc_config[0].cluster_security_group_id]) # TODO
          #}

          amiSelector = var.ami_selector
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

  context    = module.this.context
  attributes = [each.value.name]
  tags       = merge(module.this.tags, each.value.kubernetes_labels)
}
