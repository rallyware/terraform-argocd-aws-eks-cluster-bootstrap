output "velero_kms_key_arn" {
  value       = module.velero_kms_key.key_arn
  description = "Velero KMS key ARN"
}

output "velero_kms_key_id" {
  value       = module.velero_kms_key.key_id
  description = "Velero KMS key ID"
}

output "velero_s3_bucket_id" {
  value       = module.velero_s3_bucket.bucket_id
  description = "Velero S3 bucket name"
}

output "velero_s3_bucket_arn" {
  value       = module.velero_s3_bucket.bucket_arn
  description = "Velero S3 bucket ARN"
}

output "velero_service_account_role_name" {
  value       = module.velero_eks_iam_role.service_account_role_name
  description = "Velero IAM role name"
}

output "velero_service_account_role_unique_id" {
  value       = module.velero_eks_iam_role.service_account_role_unique_id
  description = "Velero IAM role unique ID"
}

output "velero_service_account_role_arn" {
  value       = module.velero_eks_iam_role.service_account_role_arn
  description = "Velero IAM role ARN"
}

output "velero_service_account_policy_name" {
  value       = module.velero_eks_iam_role.service_account_policy_name
  description = "Velero IAM policy name"
}

output "velero_service_account_policy_id" {
  value       = module.velero_eks_iam_role.service_account_policy_id
  description = "Velero IAM policy ID"
}

output "piggy_webhooks_service_account_role_name" {
  value       = module.piggy_webhooks_eks_iam_role.service_account_role_name
  description = "Piggy webhooks IAM role name"
}

output "piggy_webhooks_service_account_role_unique_id" {
  value       = module.piggy_webhooks_eks_iam_role.service_account_role_unique_id
  description = "Piggy webhooks IAM role unique ID"
}

output "piggy_webhooks_service_account_role_arn" {
  value       = module.piggy_webhooks_eks_iam_role.service_account_role_arn
  description = "Piggy webhooks IAM role ARN"
}

output "piggy_webhooks_service_account_policy_name" {
  value       = module.piggy_webhooks_eks_iam_role.service_account_policy_name
  description = "Piggy webhooks IAM policy name"
}

output "piggy_webhooks_service_account_policy_id" {
  value       = module.piggy_webhooks_eks_iam_role.service_account_policy_id
  description = "Piggy webhooks IAM policy ID"
}

output "cluster_autoscaler_service_account_role_name" {
  value       = module.cluster_autoscaler_eks_iam_role.service_account_role_name
  description = "Cluster-Autoscaler IAM role name"
}

output "cluster_autoscaler_service_account_role_unique_id" {
  value       = module.cluster_autoscaler_eks_iam_role.service_account_role_unique_id
  description = "Cluster-Autoscaler IAM role unique ID"
}

output "cluster_autoscaler_service_account_role_arn" {
  value       = module.cluster_autoscaler_eks_iam_role.service_account_role_arn
  description = "Cluster-Autoscaler IAM role ARN"
}

output "cluster_autoscaler_service_account_policy_name" {
  value       = module.cluster_autoscaler_eks_iam_role.service_account_policy_name
  description = "Cluster-Autoscaler IAM policy name"
}

output "cluster_autoscaler_service_account_policy_id" {
  value       = module.cluster_autoscaler_eks_iam_role.service_account_policy_id
  description = "Cluster-Autoscaler IAM policy ID"
}

output "ebs_csi_service_account_role_name" {
  value       = module.ebs_csi_eks_iam_role.service_account_role_name
  description = "EBS CSI driver IAM role name"
}

output "ebs_csi_service_account_role_unique_id" {
  value       = module.ebs_csi_eks_iam_role.service_account_role_unique_id
  description = "EBS CSI driver IAM role unique ID"
}

output "ebs_csi_service_account_role_arn" {
  value       = module.ebs_csi_eks_iam_role.service_account_role_arn
  description = "EBS CSI driver IAM role ARN"
}

output "ebs_csi_service_account_policy_name" {
  value       = module.ebs_csi_eks_iam_role.service_account_policy_name
  description = "EBS CSI driver IAM policy name"
}

output "ebs_csi_service_account_policy_id" {
  value       = module.ebs_csi_eks_iam_role.service_account_policy_id
  description = "EBS CSI driver IAM policy ID"
}

output "ebs_csi_kms_key_arn" {
  value       = module.ebs_csi_kms_key.key_arn
  description = "EBS CSI KMS key ARN"
}

output "ebs_csi_kms_key_id" {
  value       = module.ebs_csi_kms_key.key_id
  description = "EBS CSI KMS key ID"
}

output "tempo_s3_bucket_id" {
  value       = module.tempo_s3_bucket.bucket_id
  description = "Grafana Tempo S3 bucket name"
}

output "tempo_s3_bucket_arn" {
  value       = module.tempo_s3_bucket.bucket_arn
  description = "Grafana Tempo S3 bucket ARN"
}

output "tempo_service_account_role_name" {
  value       = module.tempo_eks_iam_role.service_account_role_name
  description = "Grafana Tempo IAM role name"
}

output "tempo_service_account_role_unique_id" {
  value       = module.tempo_eks_iam_role.service_account_role_unique_id
  description = "Grafana Tempo IAM role unique ID"
}

output "tempo_service_account_role_arn" {
  value       = module.tempo_eks_iam_role.service_account_role_arn
  description = "Grafana Tempo IAM role ARN"
}

output "tempo_service_account_policy_name" {
  value       = module.tempo_eks_iam_role.service_account_policy_name
  description = "Grafana Tempo IAM policy name"
}

output "tempo_service_account_policy_id" {
  value       = module.tempo_eks_iam_role.service_account_policy_id
  description = "Grafana Tempo IAM policy ID"
}

output "prometheus_yace_exporter_service_account_role_name" {
  value       = module.prometheus_yace_exporter_eks_iam_role.service_account_role_name
  description = "prometheus-yace-exporter IAM role name"
}

output "prometheus_yace_exporter_service_account_role_unique_id" {
  value       = module.prometheus_yace_exporter_eks_iam_role.service_account_role_unique_id
  description = "prometheus-yace-exporter IAM role unique ID"
}

output "prometheus_yace_exporter_service_account_role_arn" {
  value       = module.prometheus_yace_exporter_eks_iam_role.service_account_role_arn
  description = "prometheus-yace-exporter IAM role ARN"
}

output "loki_s3_bucket_id" {
  value       = module.loki_s3_bucket.bucket_id
  description = "Grafana Loki S3 bucket name"
}

output "loki_s3_bucket_arn" {
  value       = module.loki_s3_bucket.bucket_arn
  description = "Grafana Loki S3 bucket ARN"
}

output "loki_service_account_role_name" {
  value       = module.loki_eks_iam_role.service_account_role_name
  description = "Grafana Loki IAM role name"
}

output "loki_service_account_role_unique_id" {
  value       = module.loki_eks_iam_role.service_account_role_unique_id
  description = "Grafana Loki IAM role unique ID"
}

output "loki_service_account_role_arn" {
  value       = module.loki_eks_iam_role.service_account_role_arn
  description = "Grafana Loki IAM role ARN"
}

output "loki_service_account_policy_name" {
  value       = module.loki_eks_iam_role.service_account_policy_name
  description = "Grafana Loki IAM policy name"
}

output "loki_service_account_policy_id" {
  value       = module.loki_eks_iam_role.service_account_policy_id
  description = "Grafana Loki IAM policy ID"
}

output "karpenter_service_account_role_name" {
  value       = module.karpenter_eks_iam_role.service_account_role_name
  description = "AWS Karpenter IAM role name"
}

output "karpenter_service_account_role_unique_id" {
  value       = module.karpenter_eks_iam_role.service_account_role_unique_id
  description = "AWS Karpenter IAM role unique ID"
}

output "karpenter_service_account_role_arn" {
  value       = module.karpenter_eks_iam_role.service_account_role_arn
  description = "AWS Karpenter IAM role ARN"
}

output "karpenter_service_account_policy_name" {
  value       = module.karpenter_eks_iam_role.service_account_policy_name
  description = "AWS Karpenter IAM policy name"
}

output "karpenter_service_account_policy_id" {
  value       = module.karpenter_eks_iam_role.service_account_policy_id
  description = "AWS Karpenter IAM policy ID"
}

output "karpenter_instance_profile_name" {
  value       = module.karpenter_instance_profile.name
  description = "The name of Karpenter Instance Profile"
}

output "karpenter_instance_profile_id" {
  value       = module.karpenter_instance_profile.id
  description = "The Karpenter Instance Profile ID"
}

output "karpenter_instance_profile_arn" {
  value       = module.karpenter_instance_profile.arn
  description = "The Karpenter Instance Profile ARN"
}

output "argo_ecr_auth_service_account_role_arn" {
  value       = module.argo_ecr_auth_eks_iam_role.service_account_role_arn
  description = "argo-ecr-auth IAM role ARN"
}

output "argo_ecr_auth_service_account_role_name" {
  value       = module.argo_ecr_auth_eks_iam_role.service_account_role_name
  description = "argo-ecr-auth IAM role name"
}

output "argo_ecr_auth_service_account_role_unique_id" {
  value       = module.argo_ecr_auth_eks_iam_role.service_account_role_unique_id
  description = "argo-ecr-auth IAM role unique ID"
}

output "efs_csi_service_account_role_name" {
  value       = module.efs_csi_eks_iam_role.service_account_role_name
  description = "EFS CSI driver IAM role name"
}

output "efs_csi_service_account_role_unique_id" {
  value       = module.efs_csi_eks_iam_role.service_account_role_unique_id
  description = "EFS CSI driver IAM role unique ID"
}

output "efs_csi_service_account_role_arn" {
  value       = module.efs_csi_eks_iam_role.service_account_role_arn
  description = "EFS CSI driver IAM role ARN"
}

output "efs_csi_service_account_policy_name" {
  value       = module.efs_csi_eks_iam_role.service_account_policy_name
  description = "EFS CSI driver IAM policy name"
}

output "efs_csi_service_account_policy_id" {
  value       = module.efs_csi_eks_iam_role.service_account_policy_id
  description = "EFS CSI driver IAM policy ID"
}

output "external_secrets_service_account_role_name" {
  value       = module.external_secrets_eks_iam_role.service_account_role_name
  description = "The External-secrets operator IAM role name"
}

output "external_secrets_service_account_role_unique_id" {
  value       = module.external_secrets_eks_iam_role.service_account_role_unique_id
  description = "The External-secrets operator IAM role unique ID"
}

output "external_secrets_service_account_role_arn" {
  value       = module.external_secrets_eks_iam_role.service_account_role_arn
  description = "The External-secrets operator IAM role ARN"
}

output "external_secrets_service_account_policy_name" {
  value       = module.external_secrets_eks_iam_role.service_account_policy_name
  description = "The External-secrets operator IAM policy name"
}

output "external_secrets_service_account_policy_id" {
  value       = module.external_secrets_eks_iam_role.service_account_policy_id
  description = "The External-secrets IAM policy ID"
}

output "external_secrets_injector_role_arn" {
  value       = module.external_secrets_injector_role.arn
  description = "The External-secrets injector IAM role ARN"
}

output "keda_service_account_role_name" {
  value       = module.keda_eks_iam_role.service_account_role_name
  description = "Keda AWS IAM role name"
}

output "keda_service_account_role_unique_id" {
  value       = module.keda_eks_iam_role.service_account_role_unique_id
  description = "KEDA AWS IAM role unique ID"
}

output "keda_service_account_role_arn" {
  value       = module.keda_eks_iam_role.service_account_role_arn
  description = "KEDA AWS IAM role ARN"
}

output "keda_service_account_policy_name" {
  value       = module.keda_eks_iam_role.service_account_policy_name
  description = "KEDA AWS IAM policy name"
}

output "keda_service_account_policy_id" {
  value       = module.keda_eks_iam_role.service_account_policy_id
  description = "KEDA AWS IAM policy ID"
}
