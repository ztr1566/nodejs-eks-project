module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name                   = var.cluster_name
  cluster_version                = "1.33"
  cluster_endpoint_public_access = true
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.private_subnet_ids

  access_entries = {
    admin = {
      principal_arn = var.current_user_arn
      type          = "STANDARD"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
  }

  eks_managed_node_groups = {
    general = {
      instance_types = ["c7i-flex.large"]
      capacity_type  = "ON_DEMAND"

      min_size     = 1
      max_size     = 3
      desired_size = 2

      ami_type = "AL2023_x86_64_STANDARD"
    }
  }

  tags = {
    Environment = "production"
  }
}
