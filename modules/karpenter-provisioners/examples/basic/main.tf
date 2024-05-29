module "karpenter_provisioners" {
  source = "../../"

  ec2_node_classes = [
    {
      name               = "test"
      ami_ids            = ["ami-a", "ami-b"]
      subnet_ids         = ["subnet-a", "subnet-b", "subnet-c"]
      security_group_ids = ["sg-a"]
      instance_profile   = "karpenter-ip"

      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = "55Gi"
          }
        }
      ]
    }
  ]
  node_pools = [
    {
      name            = "test"
      node_class_name = "test"
      labels = {
        "node-group-purpose" = "test"
      }
      limits = {
        cpu    = "300"
        memory = "1200Gi"
      }
      requirements = [
        {
          key      = "kubernetes.io/os"
          operator = "In"
          values   = ["linux"]
        },
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
          key      = "karpenter.k8s.aws/instance-family"
          operator = "In"
          values   = ["t3", "t3a", "t4g"]
        },
        {
          key      = "karpenter.k8s.aws/instance-size"
          operator = "In"
          values   = ["small", "medium", "large", "xlarge", "2xlarge"]
        }
      ]
    }
  ]

  name = "karpenter"
}

output "helm_values" {
  value       = module.karpenter_provisioners.helm_values
  description = "Karpenter EC2 node classes and node-pools configuration"
}
