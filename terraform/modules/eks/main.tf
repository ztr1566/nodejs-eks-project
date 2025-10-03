module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name                   = var.cluster_name
  cluster_version                = "1.28"
  cluster_endpoint_public_access = true
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.private_subnet_ids

  aws_auth_roles = [
    {
      rolearn  = var.github_actions_role_arn
      username = "github-actions-ci"
      groups   = ["system:masters"]
    }
  ]
}


resource "aws_eks_node_group" "this" {
  cluster_name    = module.eks.cluster_name
  node_group_name = "general-workers"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = ["c7i-flex.large"]

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }

  # Ensure the IAM role and policies are in place before creating the node group
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_read_only,
  ]
}
