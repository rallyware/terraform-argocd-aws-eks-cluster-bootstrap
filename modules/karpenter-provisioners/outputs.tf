output "helm_values" {
  value       = local.helm_values
  description = "Karpenter EC2 node classes and node-pools configuration"
}
