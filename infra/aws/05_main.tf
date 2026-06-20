# main.tf
# ##############################
# VPC
# ##############################
module "vpc" {
  source = "../../modules/aws/vpc"

  vpc_name = local.vpc_name
  vpc_cidr = local.vpc_cidr
  vpc_tags = local.tags
}