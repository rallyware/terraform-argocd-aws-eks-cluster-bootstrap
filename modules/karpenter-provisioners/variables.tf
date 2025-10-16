variable "ec2_node_classes" {
  type = list(
    object(
      {
        name               = string
        ami_family         = optional(string, "AL2023")
        ami_ids            = list(string)
        subnet_ids         = list(string)
        security_group_ids = list(string)
        role               = string
        user_data          = optional(string, "")

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
            cluster_dns = null
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

        block_device_mappings = optional(
          list(
            object(
              {
                device_name = string
                ebs = object(
                  {
                    volume_type           = optional(string, "gp3")
                    volume_size           = optional(string, "35Gi")
                    delete_on_termination = optional(bool, true)
                    encrypted             = optional(bool, true)
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
        consolidation_policy = optional(string, "WhenEmptyOrUnderutilized")
        consolidate_after    = optional(string, "60s")
        labels               = optional(map(string), {})
        annotations          = optional(map(string), {})

        taints = optional(
          list(
            object(
              {
                key    = string
                effect = string
              }
            )
        ), [])

        startup_taints = optional(
          list(
            object(
              {
                key    = string
                effect = string
              }
            )
        ), [])

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
          ),
          null
        )
      }
    )
  )
  default     = []
  description = "A list of Karpenter EC2 node pools"
}
