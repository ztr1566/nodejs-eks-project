# This block tells Terraform where to find the official EKS module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0" # Use a recent version

  cluster_name    = var.cluster_name
  cluster_version = "1.28" # Specify a Kubernetes version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  # This defines the worker nodes (EC2 instances) that will run our containers
  eks_managed_node_groups = {
    one = {
      name           = "general-workers"
      instance_types = ["c7i-flex.large"] # t2.micro is too small for EKS

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }
}