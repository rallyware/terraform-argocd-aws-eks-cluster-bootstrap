variable "karpenter_node_pools" {
  type = list(object({
    name              = string
    instance_types    = list(string)
    kubernetes_labels = map(string)
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