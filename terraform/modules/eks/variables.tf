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

variable "github_actions_role_arn" {
  description = "ARN of the IAM role for GitHub Actions"
  type        = string
}