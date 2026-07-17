terraform {
   required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
}

backend "s3" {
   bucket         = "vinayak-project-backend-bucket"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "project-tf-eks-statelock"
    encrypt        = true
}

}

provider "aws" {
  region = "ap-south-1"
}
 

module "vpc" {
  source = "./modules/vpc"
  network_info = var.network_info
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones = var.availability_zones
}

module "eks" {
  source = "./modules/eks"
  node_group = var.node_group
  cluster_name = var.cluster_name
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.private_subnet_ids
  
}
 
