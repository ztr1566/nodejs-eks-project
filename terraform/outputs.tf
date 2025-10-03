output "configure_kubectl_command" {
  description = "Run this command to configure kubectl for your EKS cluster"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}"
}

output "alb_controller_iam_role_arn" {
  value = module.eks.alb_controller_iam_role_arn
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.network.public_subnet_ids
}


output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.app_repo.repository_url
}

output "github_actions_iam_role_arn" {
  description = "The ARN of the IAM Role for GitHub Actions to assume"
  value       = aws_iam_role.github_actions_ecr.arn
}