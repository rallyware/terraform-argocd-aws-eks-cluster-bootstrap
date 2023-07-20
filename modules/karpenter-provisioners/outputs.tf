output "helm_values" {
  value       = local.helm_values
  description = "Karpenter node template and provisioner configuration"
}
