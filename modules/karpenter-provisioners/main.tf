locals {
  karpenter_provisioner_values = yamlencode({ provisioners = [for node in var.karpenter_node_pools :
    {
      name = node.name
      spec = {
        ttlSecondsAfterEmpty = node.ttl_seconds_after_empty
        labels               = node.kubernetes_labels
        annotations          = node.annotations

        consolidation = {
          enabled = node.consolidation
        }

        requirements = [
          {
            key      = "karpenter.sh/capacity-type"
            operator = "In"
            values   = sort(node.capacity_type)
          },
          {
            key      = "kubernetes.io/arch"
            operator = "In"
            values   = sort(node.arch)
          },
          {
            key      = "node.kubernetes.io/instance-type"
            operator = "In"
            values   = sort(node.instance_types)
          },
          {
            key      = "topology.kubernetes.io/zone"
            operator = "In"
            values   = sort(node.vpc_azs) # TODO
          },
          {
            key      = "kubernetes.io/os"
            operator = "In"
            values   = sort(node.os)
          },
          {
            key      = "karpenter.k8s.aws/instance-category"
            operator = "In"
            values   = sort(node.instance_category)
          },
          {
            key      = "karpenter.k8s.aws/instance-cpu"
            operator = "In"
            values   = sort(node.instance_cpu)
          },
          {
            key      = "karpenter.k8s.aws/instance-hypervisor"
            operator = "In"
            values   = sort(node.instance_hypervisor)
          },
          {
            key      = "karpenter.k8s.aws/instance-generation"
            operator = "Gt"
            values   = sort(node.instance_generation)
          }
        ]

        providerRef = {
          name = node.name
        }

        taints = node.taints

        startupTaints = node.startup_taints

        kubeletConfiguration = {
          clusterDNS       = node.cluster_dns
          containerRuntime = node.container_runtime
          systemReserved = {
            cpu               = node.cpu_system_reserved
            memory            = node.memory_system_reserved
            ephemeral-storage = node.ephemeral_storage_system_reserved
          }
          kubeReserved = {
            cpu               = node.cpu_kube_reserved
            memory            = node.memory_kube_reserved
            ephemeral-storage = node.ephemeral_storage_kube_reserved
          }
          evictionHard = {
            "memory.available"  = node.memory_eviction_hard
            "nodefs.available"  = node.nodefs_eviction_hard
            "nodefs.inodesFree" = node.inodes_free_eviction_hard
          }
          evictionSoft = {
            "memory.available"  = node.memory_eviction_soft
            "nodefs.available"  = node.nodefs_eviction_soft
            "nodefs.inodesFree" = node.inodes_free_eviction_soft
          }
          evictionSoftGracePeriod = {
            "memory.available"  = node.memory_eviction_soft_grace_period
            "nodefs.available"  = node.nodefs_eviction_soft_grace_period
            "nodefs.inodesFree" = node.inodes_free_eviction_soft_grace_period
          }
          evictionMaxPodGracePeriod   = node.eviction_max_pod_grace_period
          imageGCHighThresholdPercent = node.image_gc_high_threshold_percent
          imageGCLowThresholdPercent  = node.image_gc_low_threshold_percent
          cpuCFSQuota                 = node.cpu_cfs_quota
          podsPerCore                 = node.pods_per_core
          maxPods                     = node.max_pods
        }

        limits = node.limits

        ttlSecondsUntilExpired = node.ttl_seconds_until_expired

        ttlSecondsAfterEmpty = node.ttl_seconds_after_empty

        weight = node.weight
      }
    }
    ]

    nodetemplates = [for node in var.karpenter_node_pools :
      {
        name = node.name
        spec = {
          amiFamily          = node.ami_family
          tags               = module.karpenter_provisioner_label[node.name].tags
          detailedMonitoring = node.detailed_monitoring
          instanceProfile    = node.instance_profile
          userData           = node.user_data

          subnetSelector = {
            aws-ids = join(",", local.private_subnet_ids) # TODO
          }

          securityGroupSelector = {
            aws-ids = join(",", [data.aws_eks_cluster.saas.vpc_config[0].cluster_security_group_id]) # TODO
          }

          amiSelector = {
            aws-ids = join(",", [for arch in node.arch : data.aws_ami.karpenter_provisioner[arch].id])
          }

          metadataOptions = {
            httpEndpoint            = node.metadata_http_endpoint
            httpPutResponseHopLimit = node.metadata_http_put_response_hop_limit
            httpTokens              = node.metadata_http_tokens
          }

          blockDeviceMappings = [
            {
              deviceName = node.block_device_name
              ebs = {
                volumeType          = node.volume_type
                volumeSize          = node.volume_size
                deleteOnTermination = node.device_delete_on_termination
                encrypted           = node.device_encrypted
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
  for_each = { for node in var.karpenter_node_pools : node.name => node }

  source  = "cloudposse/label/null"
  version = "0.25.0"

  name       = "karpenter"
  attributes = [each.value.name]
  context    = var.context
  tags       = each.value.kubernetes_labels
}
