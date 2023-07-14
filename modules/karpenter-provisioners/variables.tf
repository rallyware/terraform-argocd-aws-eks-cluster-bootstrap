variable "karpenter_node_pools" {
  type = list(object({
    name                      = string
    instance_types            = list(string)
    kubernetes_labels         = map(string)
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
      map(object({
        clusterDNS       = list(string)
        containerRuntime = string
        systemReserved = map(object({
          cpu               = string
          memory            = string
          ephemeral-storage = string
        }))
        kubeReserved = map(object({
          cpu               = string
          memory            = string
          ephemeral-storage = string
        }))
        evictionHard = map(object({
          "memory.available"  = string
          "nodefs.available"  = string
          "nodefs.inodesFree" = string
        }))
        evictionSoft = map(object({
          "memory.available"  = string
          "nodefs.available"  = string
          "nodefs.inodesFree" = string
        }))
        evictionSoftGracePeriod = map(object({
          "memory.available"  = string
          "nodefs.available"  = string
          "nodefs.inodesFree" = string
        }))
        evictionMaxPodGracePeriod   = number
        imageGCHighThresholdPercent = number
        imageGCLowThresholdPercent  = number
        cpuCFSQuota                 = bool
        podsPerCore                 = number
        maxPods                     = number
        })
        ), {
        clusterDNS       = null
        containerRuntime = "containerd"
        systemReserved = map(object({
          cpu               = "100m"
          memory            = "100Mi"
          ephemeral-storage = "1Gi"
        }))
        kubeReserved = map(object({
          cpu               = "100m"
          memory            = "200Mi"
          ephemeral-storage = "3Gi"
        }))
        evictionHard = map(object({
          "memory.available"  = "2%"
          "nodefs.available"  = "10%"
          "nodefs.inodesFree" = "10%"
        }))
        evictionSoft = map(object({
          "memory.available"  = "5%"
          "nodefs.available"  = "15%"
          "nodefs.inodesFree" = "15%"
        }))
        evictionSoftGracePeriod = map(object({
          "memory.available"  = "5m0s"
          "nodefs.available"  = "1m30s"
          "nodefs.inodesFree" = "2m"
        }))
        evictionMaxPodGracePeriod   = 600
        imageGCHighThresholdPercent = 85
        imageGCLowThresholdPercent  = 80
        cpuCFSQuota                 = true
        podsPerCore                 = null
        maxPods                     = 110
    })

  }))
  default     = []
  description = "A list of karpenter node-pool sets"
}

variable "node_templates" {
  type = list(object({
    name                    = string
    subnet_selector         = map(string)
    security_group_selector = map(string)
    ami_selector            = map(string)
    ami_family              = optional(string, "AL2")
    detailed_monitoring     = optional(bool, true)
    instance_profile        = optional(string, null)
    user_data               = optional(string, null)

    metadata_options = optional(
      map(object({
        httpEndpoint            = string
        httpProtocolIPv6        = string
        httpPutResponseHopLimit = number
        httpTokens              = string
      })),
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
      {
        deviceName = "/dev/xvda"
        ebs = {
          volumeType          = "gp3"
          volumeSize          = "35Gi"
          deleteOnTermination = true
          encrypted           = true
        }
    })
  }))
  default     = []
  description = "A list of karpenter node templates"

}
