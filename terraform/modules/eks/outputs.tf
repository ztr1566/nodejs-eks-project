output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "node_group_iam_role_arn" {
  description = "The ARN of the IAM role for the EKS node group."
  value       = aws_iam_role.eks_nodes.arn
}

output "alb_controller_iam_role_arn" {
  description = "ARN of the IAM role for the ALB controller"
  value       = module.iam_assumable_role_for_service_account.iam_role_arn
}

output "cluster_arn" {
  description = "The ARN of the EKS cluster."
  value       = module.eks.cluster_arn
}

output "default_storage_class" {
  description = "Name of the default storage class"
  value       = "gp3-encrypted"
  depends_on  = [null_resource.gp3_storage_class]
}
