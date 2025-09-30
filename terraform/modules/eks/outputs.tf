output "configure_kubectl" {
  description = "The command to configure kubectl for the EKS cluster."
  value       = module.eks.configure_kubectl
}