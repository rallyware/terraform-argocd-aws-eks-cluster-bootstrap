output "karpenter_provisioner_values" {
  value       = local.karpenter_provisioner_values
  description = "Karpenter node template and provisioner configuration"
}

output "karpenter_node_pools_yaml" {
  value       = yamlencode(var.karpenter_node_pools)
  description = "YAML encoded Karpenter provisioners values"
}

output "karpenter_node_pools_yaml" {
  value       = var.karpenter_node_pools
  description = "Karpenter provisioners values"
}

output "node_templates_yaml" {
  value       = yamlencode(var.node_templates)
  description = "YAML encoded Karpenter node templates"
}

output "node_templates" {
  value       = var.node_templates
  description = "Karpenter node templates"
}
