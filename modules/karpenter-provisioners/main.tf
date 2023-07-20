locals {
  helm_values = yamlencode({ provisioners = [for node in var.provisioners :
    {
      name = node.name
      spec = {
        ttlSecondsAfterEmpty = node.consolidation ? null : node.ttl_seconds_after_empty
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
            cpu               = node.kubelet_configuration.system_reserved.cpu
            memory            = node.kubelet_configuration.system_reserved.memory
            ephemeral-storage = node.kubelet_configuration.system_reserved.ephemeral_storage
          }
          kubeReserved = {
            cpu               = node.kubelet_configuration.kube_reserved.cpu
            memory            = node.kubelet_configuration.kube_reserved.memory
            ephemeral-storage = node.kubelet_configuration.kube_reserved.ephemeral_storage
          }
          evictionHard = {
            "memory.available"  = node.kubelet_configuration.eviction_hard.memory_available
            "nodefs.available"  = node.kubelet_configuration.eviction_hard.nodefs_available
            "nodefs.inodesFree" = node.kubelet_configuration.eviction_hard.nodefs_inodes_free
          }
          evictionSoft = {
            "memory.available"  = node.kubelet_configuration.eviction_soft.memory_available
            "nodefs.available"  = node.kubelet_configuration.eviction_soft.nodefs_available
            "nodefs.inodesFree" = node.kubelet_configuration.eviction_soft.nodefs_inodes_free
          }
          evictionSoftGracePeriod = {
            "memory.available"  = node.kubelet_configuration.eviction_soft_grace_period.memory_available
            "nodefs.available"  = node.kubelet_configuration.eviction_soft_grace_period.nodefs_available
            "nodefs.inodesFree" = node.kubelet_configuration.eviction_soft_grace_period.nodefs_inodes_free
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

    node_templates = [for temp in var.node_templates :
      {
        name = temp.name
        spec = {
          amiFamily          = temp.ami_family
          tags               = module.node_template_label[temp.name].tags
          detailedMonitoring = temp.detailed_monitoring
          instanceProfile    = temp.instance_profile
          userData           = temp.user_data

          subnetSelector = temp.subnet_selector

          securityGroupSelector = temp.security_group_selector

          amiSelector = temp.ami_selector

          metadataOptions = {
            httpEndpoint            = temp.metadata_options.http_endpoint
            httpProtocolIPv6        = temp.metadata_options.http_protocol_ipv6
            httpPutResponseHopLimit = temp.metadata_options.http_put_response_hop_limit
            httpTokens              = temp.metadata_options.http_tokens
          }

          blockDeviceMappings = [
            for bdm in temp.block_device_mappings : {
              deviceName = bdm.device_name
              ebs = {
                volumeType          = bdm.ebs.volume_type
                volumeSize          = bdm.ebs.volume_size
                deleteOnTermination = bdm.ebs.delete_on_termination
                encrypted           = bdm.ebs.encrypted
              }
            }
          ]
        }
      }
    ]
    }
  )
}

module "node_template_label" {
  for_each = { for node in var.provisioners : node.name => node }

  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.this.context
  attributes = [each.value.name]
  tags       = merge(module.this.tags, each.value.kubernetes_labels)
}
