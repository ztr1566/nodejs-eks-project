terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "vault" {
  address = "http://127.0.0.1:8200"
}

data "vault_generic_secret" "ami" {
  path = "secret/aws/ami"
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
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
  my_ip  = var.my_ip
}

module "ec2" {
  source            = "./modules/ec2"
  public_subnet_id  = module.network.public_subnet_id
  private_subnet_id = module.network.private_subnet_id
  web_sg_id         = module.security.web_sg_id
  private_sg_id     = module.security.private_sg_id
  key_name          = var.key_name
  instance_type     = var.instance_type
  ami_id            = data.vault_generic_secret.ami.data["ami_id"]

}
