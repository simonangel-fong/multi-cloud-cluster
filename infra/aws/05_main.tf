# main.tf

# ##############################
# VPC
# ##############################
module "vpc" {
  source = "../../modules/aws/vpc"

  vpc_name = local.common_name
  vpc_cidr = local.vpc_cidr
  vpc_tags = local.tags
}

# ##############################
# EKS
# ##############################
module "eks" {
  source = "../../modules/aws/eks"

  cluster_name    = local.common_name
  cluster_version = local.cluster_version
  subnet_ids      = module.vpc.private_subnet_ids
  cluster_tags    = local.tags
}