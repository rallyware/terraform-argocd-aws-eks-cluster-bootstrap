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

output "yace_service_account_role_name" {
  value       = module.yace_eks_iam_role.service_account_role_name
  description = "prometheus-yace-exporter IAM role name"
}

output "yace_service_account_role_unique_id" {
  value       = module.yace_eks_iam_role.service_account_role_unique_id
  description = "prometheus-yace-exporter IAM role unique ID"
}

output "yace_service_account_role_arn" {
  value       = module.yace_eks_iam_role.service_account_role_arn
  description = "prometheus-yace-exporter IAM role ARN"
}

output "yace_service_account_policy_name" {
  value       = module.yace_eks_iam_role.service_account_policy_name
  description = "prometheus-yace-exporter IAM policy name"
}

output "yace_service_account_policy_id" {
  value       = module.yace_eks_iam_role.service_account_policy_id
  description = "prometheus-yace-exporter IAM policy ID"
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
