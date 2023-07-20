variable "provisioners" {
  type = list(object({
    name                      = string
    instance_types            = list(string)
    kubernetes_labels         = optional(map(string), null)
    consolidation             = optional(bool, true)
    annotations               = optional(map(string), null)
    ttl_seconds_after_empty   = optional(number, 300)
    ttl_seconds_until_expired = optional(number, null)
    weight                    = optional(number, null)
    limits                    = optional(map(any), null)

    taints = optional(
      list(object(
        {
          key    = string
          effect = string
        }
    )), null)

    startup_taints = optional(
      list(object(
        {
          key    = string
          effect = string
        }
    )), null)

    requirements = optional(
      list(object(
        {
          key      = string
          operator = string
          values   = list(string)
        }
        )), [
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
    ])

    kubelet_configuration = optional(
      object({
        cluster_dns       = list(string)
        container_runtime = string
        system_reserved = object({
          cpu               = string
          memory            = string
          ephemeral_storage = string
        })
        kube_reserved = object({
          cpu               = string
          memory            = string
          ephemeral_storage = string
        })
        eviction_hard = object({
          memory_available   = string
          nodefs_available   = string
          nodefs_inodes_free = string
        })
        eviction_soft = object({
          memory_available   = string
          nodefs_available   = string
          nodefs_inodes_free = string
        })
        eviction_soft_grace_period = object({
          memory_available   = string
          nodefs_available   = string
          nodefs_inodes_free = string
        })
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
          cpu               = "100m"
          memory            = "100Mi"
          ephemeral_storage = "1Gi"
        }
        kube_reserved = {
          cpu               = "100m"
          memory            = "200Mi"
          ephemeral_storage = "3Gi"
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
          nodefs_inodes_free = "2m"
        }
        eviction_max_pod_grace_period   = 600
        image_gc_high_threshold_percent = 85
        image_gc_low_threshold_percent  = 80
        cpu_cfs_quota                   = true
        pods_per_core                   = null
        max_pods                        = 110
    })

  }))
  default     = []
  description = "A list of karpenter provisioners"
}

variable "node_templates" {
  type = list(object({
    name                    = string
    subnet_selector         = optional(map(any), null)
    security_group_selector = optional(map(any), null)
    ami_selector            = optional(map(any), null)
    ami_family              = optional(string, "AL2")
    detailed_monitoring     = optional(bool, true)
    instance_profile        = optional(string, null)
    user_data               = optional(string, null)

    metadata_options = optional(
      object({
        httpEndpoint            = string
        httpProtocolIPv6        = string
        httpPutResponseHopLimit = number
        httpTokens              = string
      }),
      {
        httpEndpoint            = "enabled"
        httpProtocolIPv6        = "disabled"
        httpPutResponseHopLimit = 2
        httpTokens              = "required"
    })

    block_device_mappings = optional(
      list(object({
        deviceName = string
        ebs = object({
          volumeType          = string
          volumeSize          = string
          deleteOnTermination = bool
          encrypted           = bool
        })
      })),
      [{
        deviceName = "/dev/xvda"
        ebs = {
          volumeType          = "gp3"
          volumeSize          = "35Gi"
          deleteOnTermination = true
          encrypted           = true
        }
    }])
  }))
  default     = []
  description = "A list of Karpenter node templates"
}
