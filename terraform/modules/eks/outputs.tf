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
