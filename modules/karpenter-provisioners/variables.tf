# variable "provisioners" {
#   type = list(object({
#     name                      = string
#     kubernetes_labels         = optional(map(string), null)
#     consolidation             = optional(bool, true)
#     annotations               = optional(map(string), null)
#     ttl_seconds_after_empty   = optional(number, 300)
#     ttl_seconds_until_expired = optional(number, null)
#     weight                    = optional(number, null)
#     limits                    = optional(map(any), null)

#     taints = optional(
#       list(object(
#         {
#           key    = string
#           effect = string
#         }
#     )), null)

#     startup_taints = optional(
#       list(object(
#         {
#           key    = string
#           effect = string
#         }
#     )), null)

#     requirements = optional(
#       list(object(
#         {
#           key      = string
#           operator = string
#           values   = list(string)
#         }
#         )), [
#         {
#           key      = "karpenter.sh/capacity-type"
#           operator = "In"
#           values   = ["on-demand", "spot"]
#         },
#         {
#           key      = "kubernetes.io/arch"
#           operator = "In"
#           values   = ["arm64", "amd64"]
#         }
#     ])

#     kubelet_configuration = optional(
#       object({
#         cluster_dns       = list(string)
#         container_runtime = string
#         system_reserved = object({
#           cpu               = string
#           memory            = string
#           ephemeral_storage = string
#         })
#         kube_reserved = object({
#           cpu               = string
#           memory            = string
#           ephemeral_storage = string
#         })
#         eviction_hard = object({
#           memory_available   = string
#           nodefs_available   = string
#           nodefs_inodes_free = string
#         })
#         eviction_soft = object({
#           memory_available   = string
#           nodefs_available   = string
#           nodefs_inodes_free = string
#         })
#         eviction_soft_grace_period = object({
#           memory_available   = string
#           nodefs_available   = string
#           nodefs_inodes_free = string
#         })
#         eviction_max_pod_grace_period   = number
#         image_gc_high_threshold_percent = number
#         image_gc_low_threshold_percent  = number
#         cpu_cfs_quota                   = bool
#         pods_per_core                   = number
#         max_pods                        = number
#         }
#       ),
#       {
#         cluster_dns       = null
#         container_runtime = "containerd"
#         system_reserved = {
#           cpu               = "100m"
#           memory            = "100Mi"
#           ephemeral_storage = "1Gi"
#         }
#         kube_reserved = {
#           cpu               = "100m"
#           memory            = "200Mi"
#           ephemeral_storage = "3Gi"
#         }
#         eviction_hard = {
#           memory_available   = "2%"
#           nodefs_available   = "10%"
#           nodefs_inodes_free = "10%"
#         }
#         eviction_soft = {
#           memory_available   = "5%"
#           nodefs_available   = "15%"
#           nodefs_inodes_free = "15%"
#         }
#         eviction_soft_grace_period = {
#           memory_available   = "5m0s"
#           nodefs_available   = "1m30s"
#           nodefs_inodes_free = "2m0s"
#         }
#         eviction_max_pod_grace_period   = 600
#         image_gc_high_threshold_percent = 85
#         image_gc_low_threshold_percent  = 80
#         cpu_cfs_quota                   = true
#         pods_per_core                   = null
#         max_pods                        = 110
#     })

#   }))
#   default     = []
#   description = "A list of karpenter provisioners"
# }

# variable "node_templates" {
#   type = list(object({
#     name                    = string
#     subnet_selector         = optional(map(any), null)
#     security_group_selector = optional(map(any), null)
#     ami_selector            = optional(map(any), null)
#     ami_family              = optional(string, "AL2")
#     detailed_monitoring     = optional(bool, false)
#     instance_profile        = optional(string, null)
#     user_data               = optional(string, null)

#     metadata_options = optional(
#       object({
#         http_endpoint               = string
#         http_protocol_ipv6          = string
#         http_put_response_hop_limit = number
#         http_tokens                 = string
#       }),
#       {
#         http_endpoint               = "enabled"
#         http_protocol_ipv6          = "disabled"
#         http_put_response_hop_limit = 2
#         http_tokens                 = "required"
#     })

#     block_device_mappings = optional(
#       list(object({
#         device_name = string
#         ebs = object({
#           volume_type           = string
#           volume_size           = string
#           delete_on_termination = bool
#           encrypted             = bool
#         })
#       })),
#       [{
#         device_name = "/dev/xvda"
#         ebs = {
#           volume_type           = "gp3"
#           volume_size           = "35Gi"
#           delete_on_termination = true
#           encrypted             = true
#         }
#     }])
#   }))
#   default     = []
#   description = "A list of Karpenter node templates"
# }

variable "ec2_node_classes" {
  type = list(
    object(
      {
        name               = string
        ami_family         = optional(string, "AL2")
        ami_ids            = list(string)
        subnet_ids         = list(string)
        security_group_ids = list(string)
        instance_profile   = string
        user_data          = optional(string, null)

        metadata_options = optional(
          object(
            {
              http_endpoint               = string
              http_protocol_ipv6          = string
              http_put_response_hop_limit = number
              http_tokens                 = string
            }
          ),
          {
            http_endpoint               = "enabled"
            http_protocol_ipv6          = "disabled"
            http_put_response_hop_limit = 2
            http_tokens                 = "required"
          }
        )

        block_device_mappings = optional(
          list(
            object(
              {
                device_name = string
                ebs = object(
                  {
                    volume_type           = string
                    volume_size           = string
                    delete_on_termination = bool
                    encrypted             = bool
                  }
                )
              }
            )
          ),
          [
            {
              device_name = "/dev/xvda"
              ebs = {
                volume_type           = "gp3"
                volume_size           = "35Gi"
                delete_on_termination = true
                encrypted             = true
              }
            }
          ]
        )
      }
    )
  )
  default     = []
  description = "A list of Karpenter EC2 node classes"
}

variable "node_pools" {
  type = list(
    object(
      {
        name                 = string
        node_class_name      = string
        consolidation_policy = optional(string, "WhenUnderutilized")
        consolidate_after    = optional(string, "300s")
        labels               = optional(map(string), null)
        annotations          = optional(map(string), null)

        taints = optional(
          list(
            object(
              {
                key    = string
                effect = string
              }
            )
        ), null)

        startup_taints = optional(
          list(
            object(
              {
                key    = string
                effect = string
              }
            )
        ), null)

        requirements = optional(
          list(
            object(
              {
                key      = string
                operator = string
                values   = list(string)
              }
            )
          ),
          [
            {
              key      = "karpenter.sh/capacity-type"
              operator = "In"
              values   = ["on-demand", "spot"]
            },
            {
              key      = "kubernetes.io/arch"
              operator = "In"
              values   = ["arm64", "amd64"]
            }
          ]
        )

        limits = optional(
          object(
            {
              cpu    = string
              memory = string
            }
        ), null)

        kubelet = optional(
          object(
            {
              cluster_dns = optional(list(string), null)
              system_reserved = object(
                {
                  cpu               = string
                  memory            = string
                  ephemeral_storage = string
                }
              )
              kube_reserved = object(
                {
                  cpu               = string
                  memory            = string
                  ephemeral_storage = string
                }
              )
              eviction_hard = object(
                {
                  memory_available   = string
                  nodefs_available   = string
                  nodefs_inodes_free = string
                }
              )
              eviction_soft = object(
                {
                  memory_available   = string
                  nodefs_available   = string
                  nodefs_inodes_free = string
                }
              )
              eviction_soft_grace_period = object(
                {
                  memory_available   = string
                  nodefs_available   = string
                  nodefs_inodes_free = string
                }
              )
              eviction_max_pod_grace_period   = number
              image_gc_high_threshold_percent = number
              image_gc_low_threshold_percent  = number
              cpu_cfs_quota                   = bool
              pods_per_core                   = number
              max_pods                        = number
            }
          ),
          {
            cluster_dns       = null
            container_runtime = "containerd"
            system_reserved = {
              cpu               = "50m"
              memory            = "100Mi"
              ephemeral_storage = "1Gi"
            }
            kube_reserved = {
              cpu               = "50m"
              memory            = "100Mi"
              ephemeral_storage = "1Gi"
            }
            eviction_hard = {
              memory_available   = "2%"
              nodefs_available   = "10%"
              nodefs_inodes_free = "10%"
            }
            eviction_soft = {
              memory_available   = "5%"
              nodefs_available   = "15%"
              nodefs_inodes_free = "15%"
            }
            eviction_soft_grace_period = {
              memory_available   = "5m0s"
              nodefs_available   = "1m30s"
              nodefs_inodes_free = "2m0s"
            }
            eviction_max_pod_grace_period   = 600
            image_gc_high_threshold_percent = 85
            image_gc_low_threshold_percent  = 80
            cpu_cfs_quota                   = false
            pods_per_core                   = null
            max_pods                        = 110
          }
        )
      }
    )
  )
  default     = []
  description = "A list of Karpenter EC2 node pools"
}
