terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
}

module "network" {
  source              = "./modules/network"
  vpc_id              = module.vpc.vpc_id
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  aws_region          = var.region
}

data "aws_caller_identity" "current" {}

module "eks" {
  source             = "./modules/eks"
  cluster_name       = "${var.project_name}-cluster"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  current_user_arn = data.aws_caller_identity.current.arn

  cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent            = true
    }
  }

  app_repo_arn          = aws_ecr_repository.app_repo.arn
  kaniko_cache_repo_arn = aws_ecr_repository.kaniko_cache_repo.arn
}
