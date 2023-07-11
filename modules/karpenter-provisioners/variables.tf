variable "karpenter_node_pools" {
  type = list(object({
    name                                   = string
    instance_types                         = list(string)
    kubernetes_labels                      = map(string)
    annotations                            = optional(map(string), null)
    taints                                 = optional(map(string), null)
    startup_taints                         = optional(map(string), null)
    limits                                 = optional(map(any), null)
    consolidation                          = optional(bool, false)
    capacity_type                          = optional(list(string), ["on-demand", "spot"])
    arch                                   = optional(list(string), ["arm64", "amd64"])
    os                                     = optional(list(string), ["linux"])
    instance_category                      = optional(list(string), ["m", "r", "t"])
    instance_cpu                           = optional(list(string), ["2", "4", "8", "16"])
    instance_hypervisor                    = optional(list(string), ["nitro"])
    instance_generation                    = optional(list(string), ["2"])
    ttl_seconds_after_empty                = optional(number, 300)
    vpc_azs                                = optional(list(string), ["eu-central-1a", "eu-central-1b", "eu-central-1c"])
    cluster_dns                            = optional(list(string), ["10.0.1.100"])
    container_runtime                      = optional(string, "containerd")
    cpu_system_reserved                    = optional(string, "100m")
    memory_system_reserved                 = optional(string, "100Mi")
    ephemeral_storage_system_reserved      = optional(string, "1Gi")
    cpu_kube_reserved                      = optional(string, "100m")
    memory_kube_reserved                   = optional(string, "200Mi")
    ephemeral_storage_kube_reserved        = optional(string, "3Gi")
    memory_eviction_hard                   = optional(string, "2%")
    nodefs_eviction_hard                   = optional(string, "10%")
    inodes_free_eviction_hard              = optional(string, "10%")
    memory_eviction_soft                   = optional(string, "5%")
    nodefs_eviction_soft                   = optional(string, "15%")
    inodes_free_eviction_soft              = optional(string, "15%")
    memory_eviction_soft_grace_period      = optional(string, "5m0s")
    nodefs_eviction_soft_grace_period      = optional(string, "1m30s")
    inodes_free_eviction_soft_grace_period = optional(string, "2m")
    eviction_max_pod_grace_period          = optional(number, 600)
    image_gc_high_threshold_percent        = optional(number, 85)
    image_gc_low_threshold_percent         = optional(number, 80)
    cpu_cfs_quota                          = optional(bool, true)
    pods_per_core                          = optional(number, 2)
    max_pods                               = optional(number, 110)
    ttl_seconds_until_expired              = optional(number, 2592000)
    ttl_seconds_after_empty                = optional(number, 30)
    weight                                 = optional(number, 0)
    ami_family                             = optional(string, "AL2")
    detailed_monitoring                    = optional(bool, true)
    instance_profile                       = optional(string, null)
    user_data                              = optional(string, null)
    metadata_http_endpoint                 = optional(string, "enabled")
    metadata_http_put_response_hop_limit   = optional(number, 2)
    metadata_http_tokens                   = optional(string, "required")
    block_device_name                      = optional(string, "/dev/xvda")
    volume_type                            = optional(string, "gp3")
    volume_size                            = optional(string, "35Gi")
    device_delete_on_termination           = optional(bool, true)
    device_encrypted                       = optional(bool, true)
  }))
  default = [
    {
      name           = "web-s"
      instance_types = ["t4g.small", "t3a.small", "t3.small"]

      kubernetes_labels = {
        "node-group-purpose" = "web"
        "plan"               = "S"
      }
    },
    {
      name           = "web-m"
      instance_types = ["t4g.medium", "m6g.medium", "m6gd.medium", "t3a.medium", "t3.medium"]

      kubernetes_labels = {
        "node-group-purpose" = "web"
        "plan"               = "M"
      }
    },
    {
      name           = "web-l"
      instance_types = ["m6g.large", "m6gd.large", "t4g.large", "m6a.large", "m5a.large", "m5.large", "m5n.large"]

      kubernetes_labels = {
        "node-group-purpose" = "web"
        "plan"               = "L"
      }
    },
    {
      name           = "web-xl"
      instance_types = ["m6g.xlarge", "m6gd.xlarge", "t4g.xlarge", "m6a.xlarge", "m5a.xlarge", "m5.xlarge", "m5n.xlarge"]

      kubernetes_labels = {
        "node-group-purpose" = "web"
        "plan"               = "XL"
      }
    },
    {
      name           = "web-xxl"
      instance_types = ["m6g.2xlarge", "m6gd.2xlarge", "t4g.2xlarge", "m6a.2xlarge", "m5a.2xlarge", "m5.2xlarge", "m5n.2xlarge"]

      kubernetes_labels = {
        "node-group-purpose" = "web"
        "plan"               = "XXL"
      }
    },
    {
      name           = "worker-s"
      instance_types = ["t4g.small", "t3a.small", "t3.small"]

      kubernetes_labels = {
        "node-group-purpose" = "worker"
        "plan"               = "S"
      }
    },
    {
      name           = "worker-m"
      instance_types = ["t4g.medium", "m6g.medium", "m6gd.medium", "t3a.medium", "t3.medium"]

      kubernetes_labels = {
        "node-group-purpose" = "worker"
        "plan"               = "M"
      }
    },
    {
      name           = "worker-l"
      instance_types = ["m6g.large", "m6gd.large", "t4g.large", "m6a.large", "m5a.large", "m5.large", "m5n.large"]

      kubernetes_labels = {
        "node-group-purpose" = "worker"
        "plan"               = "L"
      }
    },
    {
      name           = "worker-xl"
      instance_types = ["m6g.xlarge", "m6gd.xlarge", "t4g.xlarge", "m6a.xlarge", "m5a.xlarge", "m5.xlarge", "m5n.xlarge"]

      kubernetes_labels = {
        "node-group-purpose" = "worker"
        "plan"               = "XL"
      }
    },
    {
      name           = "worker-xxl"
      instance_types = ["m6g.2xlarge", "m6gd.2xlarge", "t4g.2xlarge", "m6a.2xlarge", "m5a.2xlarge", "m5.2xlarge", "m5n.2xlarge"]

      kubernetes_labels = {
        "node-group-purpose" = "worker"
        "plan"               = "XXL"
      }
    },
    {
      name           = "migrations"
      instance_types = ["t4g.medium", "m6g.medium", "m6gd.medium", "t3a.medium", "t3.medium"]

      kubernetes_labels = {
        "node-group-purpose" = "migrations"
      }
    },
    {
      name           = "redis"
      instance_types = ["t4g.small", "t3a.small", "t3.small"]

      kubernetes_labels = {
        "node-group-purpose" = "redis"
      }
    },
    {
      name           = "redis-prod"
      instance_types = ["t4g.small", "t3a.small", "t3.small"]

      kubernetes_labels = {
        "node-group-purpose" = "redis-prod"
      }
    },
    {
      name           = "elasticsearch"
      instance_types = ["r6g.large", "r6gd.large", "t4g.xlarge", "m6g.xlarge", "m6gd.xlarge", "r5a.large", "r5.large", "r5ad.large"]

      kubernetes_labels = {
        "node-group-purpose" = "elasticsearch"
      }
    },
    {
      name           = "infra"
      instance_types = ["t4g.medium", "m6g.medium", "m6gd.medium", "t3a.medium", "t3.medium"]

      kubernetes_labels = {
        "node-group-purpose" = "infra"
      }
    },
  ]
  description = "A list of karpenter node-pool sets"
}
