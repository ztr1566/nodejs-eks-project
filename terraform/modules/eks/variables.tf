# terraform/modules/eks/variables.tf

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the cluster will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs for the EKS worker nodes"
  type        = list(string)
}

variable "cluster_addons" {
  description = "Map of EKS cluster addons to enable."
  type        = map(any)
  default     = {}
}

variable "app_repo_arn" {
  description = "The ARN of the main application ECR repository"
  type        = string
}

variable "kaniko_cache_repo_arn" {
  description = "The ARN of the Kaniko cache ECR repository"
  type        = string
}