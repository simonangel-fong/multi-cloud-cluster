locals {

  # ##############################
  # Metadata
  # ##############################
  common_name = "${var.project_name}-${var.env}"

  # ##############################
  # AWS
  # ##############################
  tags = {
    Project     = var.project_name
    Environment = var.env
    ManagedBy   = "terraform"
  }

  # VPC
  vpc_cidr = "10.0.0.0/16"

  # EKS
  cluster_version = "1.36"
}
