output "public_ec2_ip" {
  value = module.ec2.public_ip
}

output "configure_kubectl_command" {
  description = "Run this command to configure kubectl for your EKS cluster"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}"
}

output "alb_controller_iam_role_arn" {
  value = module.eks.alb_controller_iam_role_arn
}