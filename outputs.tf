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

output "ebs_csi_kms_key_arn" {
  value       = module.ebs_csi_kms_key.key_arn
  description = "EBS CSI KMS key ARN"
}

output "ebs_csi_kms_key_id" {
  value       = module.ebs_csi_kms_key.key_id
  description = "EBS CSI KMS key ID"
}
