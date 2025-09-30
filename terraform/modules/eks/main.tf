module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name                   = var.cluster_name
  cluster_version                = "1.28"
  cluster_endpoint_public_access = true
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.private_subnet_ids

  eks_managed_node_groups = {
    one = {
      name                       = "general-workers"
      instance_types             = ["c7i-flex.large"]
      min_size                   = 1
      max_size                   = 3
      desired_size               = 2
      create_iam_role            = false
      iam_role_arn               = aws_iam_role.eks_nodes.arn
      iam_role_attach_cni_policy = false
    }
  }
}
