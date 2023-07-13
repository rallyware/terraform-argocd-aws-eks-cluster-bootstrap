variable "karpenter_node_pools" {
  type = list(object({
    name                      = string
    instance_types            = list(string)
    kubernetes_labels         = map(string)
    annotations               = optional(map(string), null)
    ttl_seconds_after_empty   = optional(number, 300)
    ttl_seconds_until_expired = optional(number, 2592000)
    weight                    = optional(number, 0)
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
        },
        {
          key      = "node.kubernetes.io/instance-type"
          operator = "In"
          values   = ["t4g.small", "t3a.small", "t3.small"]
        },
        {
          key      = "topology.kubernetes.io/zone"
          operator = "In"
          values   = ["eu-central-1a", "eu-central-1b", "eu-central-1c"] # TODO
        },
        {
          key      = "kubernetes.io/os"
          operator = "In"
          values   = ["linux"]
        },
        {
          key      = "karpenter.k8s.aws/instance-category"
          operator = "In"
          values   = ["m", "r", "t"]
        },
        {
          key      = "karpenter.k8s.aws/instance-cpu"
          operator = "In"
          values   = ["2", "4", "8", "16"]
        },
        {
          key      = "karpenter.k8s.aws/instance-hypervisor"
          operator = "In"
          values   = ["nitro"]
        },
        {
          key      = "karpenter.k8s.aws/instance-generation"
          operator = "Gt"
          values   = ["2"]
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
        clusterDNS       = ["10.0.1.100"]
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
        podsPerCore                 = 2
        maxPods                     = 110
    })

  }))
  default = [
    {
      name = "web-s"
      requirements = [{
        key      = "node.kubernetes.io/instance-type"
        operator = "In"
        values   = ["t4g.small", "t3a.small", "t3.small"]
      }]

      kubernetes_labels = {
        "node-group-purpose" = "web"
        "plan"               = "S"
      }
    },
    {
      name = "web-m"
      requirements = [{
        key      = "node.kubernetes.io/instance-type"
        operator = "In"
        values   = ["t4g.medium", "m6g.medium", "m6gd.medium", "t3a.medium", "t3.medium"]
      }]

      kubernetes_labels = {
        "node-group-purpose" = "web"
        "plan"               = "M"
      }
    },
    {
      name = "web-l"
      requirements = [{
        key      = "node.kubernetes.io/instance-type"
        operator = "In"
        values   = ["m6g.large", "m6gd.large", "t4g.large", "m6a.large", "m5a.large", "m5.large", "m5n.large"]
      }]

      kubernetes_labels = {
        "node-group-purpose" = "web"
        "plan"               = "L"
      }
    },
    {
      name = "web-xl"
      requirements = [{
        key      = "node.kubernetes.io/instance-type"
        operator = "In"
        values   = ["m6g.xlarge", "m6gd.xlarge", "t4g.xlarge", "m6a.xlarge", "m5a.xlarge", "m5.xlarge", "m5n.xlarge"]
      }]

      kubernetes_labels = {
        "node-group-purpose" = "web"
        "plan"               = "XL"
      }
    },
    {
      name = "web-xxl"
      requirements = [{
        key      = "node.kubernetes.io/instance-type"
        operator = "In"
        values   = ["m6g.2xlarge", "m6gd.2xlarge", "t4g.2xlarge", "m6a.2xlarge", "m5a.2xlarge", "m5.2xlarge", "m5n.2xlarge"]
      }]

      kubernetes_labels = {
        "node-group-purpose" = "web"
        "plan"               = "XXL"
      }
    },
    {
      name = "worker-s"
      requirements = [{
        key      = "node.kubernetes.io/instance-type"
        operator = "In"
        values   = ["t4g.small", "t3a.small", "t3.small"]
      }]

      kubernetes_labels = {
        "node-group-purpose" = "worker"
        "plan"               = "S"
      }
    },
    {
      name = "worker-m"
      requirements = [{
        key      = "node.kubernetes.io/instance-type"
        operator = "In"
        values   = ["t4g.medium", "m6g.medium", "m6gd.medium", "t3a.medium", "t3.medium"]
      }]

      kubernetes_labels = {
        "node-group-purpose" = "worker"
        "plan"               = "M"
      }
    },
    {
      name = "worker-l"
      requirements = [{
        key      = "node.kubernetes.io/instance-type"
        operator = "In"
        values   = ["m6g.large", "m6gd.large", "t4g.large", "m6a.large", "m5a.large", "m5.large", "m5n.large"]
      }]

      kubernetes_labels = {
        "node-group-purpose" = "worker"
        "plan"               = "L"
      }
    },
    {
      name = "worker-xl"
      requirements = [{
        key      = "node.kubernetes.io/instance-type"
        operator = "In"
        values   = ["m6g.xlarge", "m6gd.xlarge", "t4g.xlarge", "m6a.xlarge", "m5a.xlarge", "m5.xlarge", "m5n.xlarge"]
      }]

      kubernetes_labels = {
        "node-group-purpose" = "worker"
        "plan"               = "XL"
      }
    },
    {
      name = "worker-xxl"
      requirements = [{
        key      = "node.kubernetes.io/instance-type"
        operator = "In"
        values   = ["m6g.2xlarge", "m6gd.2xlarge", "t4g.2xlarge", "m6a.2xlarge", "m5a.2xlarge", "m5.2xlarge", "m5n.2xlarge"]
      }]

      kubernetes_labels = {
        "node-group-purpose" = "worker"
        "plan"               = "XXL"
      }
    },
    {
      name = "migrations"
      requirements = [{
        key      = "node.kubernetes.io/instance-type"
        operator = "In"
        values   = ["t4g.medium", "m6g.medium", "m6gd.medium", "t3a.medium", "t3.medium"]
      }]

      kubernetes_labels = {
        "node-group-purpose" = "migrations"
      }
    },
    {
      name = "redis"
      requirements = [{
        key      = "node.kubernetes.io/instance-type"
        operator = "In"
        values   = ["t4g.small", "t3a.small", "t3.small"]
      }]

      kubernetes_labels = {
        "node-group-purpose" = "redis"
      }
    },
    {
      name = "redis-prod"
      requirements = [{
        key      = "node.kubernetes.io/instance-type"
        operator = "In"
        values   = ["t4g.small", "t3a.small", "t3.small"]
      }]

      kubernetes_labels = {
        "node-group-purpose" = "redis-prod"
      }
    },
    {
      name = "elasticsearch"
      requirements = [{
        key      = "node.kubernetes.io/instance-type"
        operator = "In"
        values   = ["r6g.large", "r6gd.large", "t4g.xlarge", "m6g.xlarge", "m6gd.xlarge", "r5a.large", "r5.large", "r5ad.large"]
      }]

      kubernetes_labels = {
        "node-group-purpose" = "elasticsearch"
      }
    },
    {
      name = "infra"
      requirements = [{
        key      = "node.kubernetes.io/instance-type"
        operator = "In"
        values   = ["t4g.medium", "m6g.medium", "m6gd.medium", "t3a.medium", "t3.medium"]
      }]

      kubernetes_labels = {
        "node-group-purpose" = "infra"
      }
    },
  ]
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
  default = [
    {
      name = "web-s"
    },
    {
      name = "web-m"
    },
    {
      name = "web-l"
    },
    {
      name = "web-xl"
    },
    {
      name = "web-xxl"
    },
    {
      name = "worker-s"
    },
    {
      name = "worker-m"
    },
    {
      name = "worker-l"
    },
    {
      name = "worker-xl"
    },
    {
      name = "worker-xxl"
    },
    {
      name = "migrations"
    },
    {
      name = "redis"
    },
    {
      name = "redis-prod"
    },
    {
      name = "elasticsearch"
    },
    {
      name = "infra"
    },
  ]
  description = "A list of karpenter node templates"

}
