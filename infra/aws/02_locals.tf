locals {

  # ##############################
  # Project
  # ##############################
  project_name = "gitops"

  # ##############################
  # Cloudflare DNS
  # ##############################
  domain = "arguswatcher.net"

  # ##############################
  # AWS
  # ##############################
  tags = {
    Project     = var.project_name
    Environment = var.env
    ManagedBy   = "terraform"
  }

  name = "${local.project_name}-${var.env}"

  # ##############################
  # VPC
  # ##############################
  vpc_name = "${local.project_name}-${var.env}"
  vpc_cidr = "10.0.0.0/16"

}