locals {
  helm_values = yamlencode(
    {
      ec2NodeClasses = [for node in var.ec2_node_classes :
        {
          name             = node.name
          amiFamily        = node.ami_family
          amiIDs           = node.ami_ids
          subnetIDs        = node.subnet_ids
          securityGroupIDs = node.security_group_ids
          role             = node.role
          tags             = module.node_template_label[node.name].tags
          userData         = node.user_data

          metadataOptions = {
            httpEndpoint            = node.metadata_options.http_endpoint
            httpProtocolIPv6        = node.metadata_options.http_protocol_ipv6
            httpPutResponseHopLimit = node.metadata_options.http_put_response_hop_limit
            httpTokens              = node.metadata_options.http_tokens
          }

          blockDeviceMappings = [
            for bdm in node.block_device_mappings : {
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
      ]

      nodePools = [for node in var.node_pools :
        {
          name                = node.name
          nodeClassName       = node.node_class_name
          consolidationPolicy = node.consolidation_policy
          consolidateAfter    = node.consolidate_after
          annotations         = node.annotations
          labels              = node.labels
          taints              = node.taints
          startupTaints       = node.startup_taints
          requirements        = node.requirements
          limits              = node.limits == null ? {} : node.limits

          kubelet = {
            clusterDNS = node.kubelet.cluster_dns
            systemReserved = {
              cpu               = node.kubelet.system_reserved.cpu
              memory            = node.kubelet.system_reserved.memory
              ephemeral-storage = node.kubelet.system_reserved.ephemeral_storage
            }

            kubeReserved = {
              cpu               = node.kubelet.kube_reserved.cpu
              memory            = node.kubelet.kube_reserved.memory
              ephemeral-storage = node.kubelet.kube_reserved.ephemeral_storage
            }

            evictionHard = {
              "memory.available"  = node.kubelet.eviction_hard.memory_available
              "nodefs.available"  = node.kubelet.eviction_hard.nodefs_available
              "nodefs.inodesFree" = node.kubelet.eviction_hard.nodefs_inodes_free
            }

            evictionSoft = {
              "memory.available"  = node.kubelet.eviction_soft.memory_available
              "nodefs.available"  = node.kubelet.eviction_soft.nodefs_available
              "nodefs.inodesFree" = node.kubelet.eviction_soft.nodefs_inodes_free
            }

            evictionSoftGracePeriod = {
              "memory.available"  = node.kubelet.eviction_soft_grace_period.memory_available
              "nodefs.available"  = node.kubelet.eviction_soft_grace_period.nodefs_available
              "nodefs.inodesFree" = node.kubelet.eviction_soft_grace_period.nodefs_inodes_free
            }
            evictionMaxPodGracePeriod   = node.kubelet.eviction_max_pod_grace_period
            imageGCHighThresholdPercent = node.kubelet.image_gc_high_threshold_percent
            imageGCLowThresholdPercent  = node.kubelet.image_gc_low_threshold_percent
            cpuCFSQuota                 = node.kubelet.cpu_cfs_quota
            podsPerCore                 = node.kubelet.pods_per_core
            maxPods                     = node.kubelet.max_pods
          }
        }
      ]
    }
  )
}

module "node_template_label" {
  for_each = { for node in var.ec2_node_classes : node.name => node }

  source  = "cloudposse/label/null"
  version = "0.25.0"

  context    = module.this.context
  attributes = [each.value.name]
}
